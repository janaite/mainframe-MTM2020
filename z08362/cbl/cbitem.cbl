      *****************************************************************
      * Program name:    CBITEM
      * Original author: JORGE JANAITE NETO
      * Date:            20210109
      *
      * Changes:
      *---------
      * 20210109: initial release
      * 20210113: input extended from 5 to 12 bits
      * 20210114: added single combinations support (PARM=00)
      * 20210115: BUGFIX no more abend when input is empty
      *
      *****************************************************************
      * COMBINES ITEMS BETWEEN THEM with commom prefix
      *
      * PARMS: length of prefix (number of '1's from right to left)
      *        that both items must have to be combined into a new one
      *
      * INPUT: dataset MUST BE A RDDS DATASET
      *        with layout PIC X(12) with only '1' OR '0' IN SEQUENCE
      *        where '1' means feature present, '0' not present
      *
      * OUTPUT: a dataset with the same PIC X(12) with only '1' or '0'
      *         inside each sequence
      *
      * Sample (all sample filled left with 0000000):
      *    parm=1
      *    input:  00011, 01001, 10001, 01010, 10010, 11000
      *    output: 01011, 10011, 11001, 11010
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.  CBITEM.
       AUTHOR.      JORGE JANAITE NETO.

       ENVIRONMENT DIVISION.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT COMB-FILE ASSIGN TO COMBDATA
              ORGANIZATION IS RELATIVE
              ACCESS MODE IS RANDOM
              RELATIVE KEY IS COMB-FILE-KEY
              FILE STATUS IS FS1.

           SELECT OUT-FILE ASSIGN TO OUTDATA
              ORGANIZATION IS SEQUENTIAL
              ACCESS MODE IS SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

       FD  COMB-FILE.
       01  COMB-REC.
           05 SEQ     PIC X(12).
           05 SEQ-CNT PIC 9(9).

       FD  OUT-FILE.
       01  OUT-REC.
           05 SEQ2 PIC X(12).

       WORKING-STORAGE SECTION.

       01  WS-EOF            PIC A(1)    VALUE 'N'.
       01  WS-EOF-CURRENT    PIC A(1).

       01  FS1               PIC X(2).
       01  COMB-FILE-KEY     PIC 9(5)    VALUE 0.
       01  WS-CURRENT-PTR    PIC 9(5)    VALUE 0.
       01  WS-BASE-PTR       PIC 9(5)    VALUE 0.

       01  WS-BASE           PIC X(12).
       01  WS-BASE-PREFIX    PIC X(12).
       01  WS-CURRENT        PIC X(12).
       01  WS-CURRENT-PREFIX PIC X(12).
       01  WS-OUTPUT         PIC X(12).

       01  I                 PIC 99.
       01  CNT               PIC 9(2).
       01  WS-PREFIX-SIZE    PIC 9(2)    VALUE 1.

       LINKAGE SECTION.
       01   PARM-BUFFER.
           05 PARM-LENGTH    PIC S9(4) USAGE COMP.
           05 PARM-DATA.
              10 PARM-VAL    PIC X(2).

       PROCEDURE DIVISION USING PARM-BUFFER.
           MOVE PARM-VAL TO WS-PREFIX-SIZE.
           PERFORM OPEN-DATA.
           IF WS-PREFIX-SIZE < 1 THEN
              PERFORM COMBINATORY-BASE0 UNTIL WS-EOF = 'Y'
           ELSE
              PERFORM COMBINATORY-BASE UNTIL WS-EOF = 'Y'
           END-IF.
           PERFORM CLOSE-DATA.
           STOP RUN.

       COMBINATORY-BASE0.
           PERFORM NEXT-BASE.
           PERFORM REPOSITION-CURRENT.
           PERFORM UNTIL WS-EOF-CURRENT = 'Y'
              PERFORM GENERATE-OUTPUT
              PERFORM NEXT-CURRENT
           END-PERFORM.

       COMBINATORY-BASE.
           PERFORM NEXT-BASE.
      *    IF WS-EOF = 'Y' THEN EXIT.
           PERFORM REPOSITION-CURRENT.
           PERFORM UNTIL WS-EOF-CURRENT = 'Y'
              IF WS-BASE-PREFIX = WS-CURRENT-PREFIX THEN
                 PERFORM GENERATE-OUTPUT
                 PERFORM NEXT-CURRENT
              ELSE
                 MOVE 'Y' TO WS-EOF-CURRENT
              END-IF
           END-PERFORM.

       GENERATE-OUTPUT.
           MOVE ZEROS TO WS-OUTPUT.
           PERFORM VARYING I FROM LENGTH OF WS-BASE BY -1 UNTIL I = 0
              IF WS-BASE(I:1) = '1' OR WS-CURRENT(I:1) = '1' THEN
                 MOVE '1' TO WS-OUTPUT(I:1)
              END-IF
           END-PERFORM.
           MOVE WS-OUTPUT TO OUT-REC.
           WRITE OUT-REC.

       NEXT-CURRENT.
           MOVE 'N' TO WS-EOF-CURRENT.
           ADD 1 TO WS-CURRENT-PTR.
           MOVE WS-CURRENT-PTR TO COMB-FILE-KEY.
           READ COMB-FILE
              INVALID KEY MOVE 'Y' TO WS-EOF-CURRENT
           END-READ.
      *     DISPLAY "NEXT-CURRENT FS1=" FS1.
      *     IF FS1 = 0 THEN
              MOVE COMB-REC TO WS-CURRENT.
              PERFORM UPDATE-CURRENT-PREFIX.
      *     ELSE
      *        MOVE 'Y' TO WS-EOF-CURRENT
      *     END-IF.

       NEXT-BASE.
           ADD 1 TO WS-BASE-PTR.
           MOVE WS-BASE-PTR TO COMB-FILE-KEY.
           READ COMB-FILE
              INVALID KEY MOVE 'Y' TO WS-EOF
           END-READ.
           IF FS1 = 47 THEN
              PERFORM CLOSE-DATA
              STOP RUN
           END-IF.
      *     DISPLAY "NEXT-BASE FS1=" FS1.
      *     IF FS1 = 0 THEN
              MOVE COMB-REC TO WS-BASE.
              PERFORM UPDATE-BASE-PREFIX.
      *     ELSE
      *        MOVE 'Y' TO WS-EOF
      *     END-IF.

       REPOSITION-CURRENT.
           MOVE WS-BASE-PTR TO WS-CURRENT-PTR.
           PERFORM NEXT-CURRENT.

       UPDATE-BASE-PREFIX.
           MOVE ZEROS TO WS-BASE-PREFIX.
           MOVE 0 TO CNT.
           PERFORM VARYING I FROM LENGTH OF WS-BASE BY -1 UNTIL I = 0
              IF WS-BASE(I:1) = '1' THEN
                 MOVE '9' TO WS-BASE-PREFIX(I:1)
                 ADD 1 TO CNT
                 IF CNT = WS-PREFIX-SIZE THEN
                    EXIT PERFORM
                 END-IF
              END-IF
           END-PERFORM.

       UPDATE-CURRENT-PREFIX.
           MOVE ZEROS TO WS-CURRENT-PREFIX.
           MOVE 0 TO CNT.
           PERFORM VARYING I FROM LENGTH OF WS-CURRENT BY -1 UNTIL I = 0
              IF WS-CURRENT(I:1) = '1' THEN
                 MOVE '9' TO WS-CURRENT-PREFIX(I:1)
                 ADD 1 TO CNT
                 IF CNT = WS-PREFIX-SIZE THEN
                    EXIT PERFORM
                 END-IF
              END-IF
           END-PERFORM.

       OPEN-DATA.
           OPEN INPUT COMB-FILE.
           MOVE 1 TO COMB-FILE-KEY.

           OPEN OUTPUT OUT-FILE.

       CLOSE-DATA.
           CLOSE COMB-FILE.
           CLOSE OUT-FILE.
