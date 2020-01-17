      *****************************************************************
      * Program name:    FTFREQ
      * Original author: JORGE JANAITE NETO
      * Date:            20210110
      *
      * Changes:
      *---------
      * 20210111: added output of total registers count
      * 20210113: extended from 5 to 12 bits
      *
      *****************************************************************
      * COUNT FREQUENCY OF FEATURES BASED UPON A MASK FROM A DATASET
      *
      * INPUT:
      *    FEATDATA dataset MUST BE A RDDS DATASET
      *        with layout PIC X(12) with only '1' OR '0' IN SEQUENCE
      *        where '1' means feature present, '0' not present
      *
      *    CNTLDATA data set
      *        with layout PIC X(12) with only '1' OR '0' IN SEQUENCE
      *        where '1' means feature present.
      *        the combination must be present on feature data to be
      *        accounted into frequency counter
      *
      * OUTPUT:
      *    OUTDATA dataset with layout:
      *          PIC X(12) = the same as CNTLDATA
      *          PIC 9(9) = fequency counter
      *    TOTALREG features count with PIC 9(9)
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.  FTFREQ.
       AUTHOR.      JORGE JANAITE NETO.

       ENVIRONMENT DIVISION.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT FEATURE-FILE ASSIGN TO FEATDATA
              ORGANIZATION IS RELATIVE
              ACCESS MODE IS DYNAMIC
              RELATIVE KEY IS FEATURE-FILE-KEY
              FILE STATUS IS FS1.

           SELECT CONTROL-FILE ASSIGN TO CNTLDATA
              ORGANIZATION IS SEQUENTIAL
              ACCESS MODE IS SEQUENTIAL.

           SELECT OUT-FILE ASSIGN TO OUTDATA
              ORGANIZATION IS SEQUENTIAL
              ACCESS MODE IS SEQUENTIAL.

           SELECT TOTALREG-FILE ASSIGN TO TOTALREG
              ORGANIZATION IS SEQUENTIAL
              ACCESS MODE IS SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

       FD  FEATURE-FILE.
       01  FEATURE-REC.
           05  SEQ PIC X(12).

       FD  CONTROL-FILE.
       01  CONTROL-REC.
           05  SEQ PIC X(12).

       FD  OUT-FILE.
       01  OUT-REC.
           05 OUT-SEQ  PIC X(12).
           05 OUT-FREQ PIC 9(9).

       FD  TOTALREG-FILE.
       01  TOTALREG-REC.
           05 TOTAL-REG-COUNT PIC 9(9).

       WORKING-STORAGE SECTION.
       01  FEATURE-FILE-KEY  PIC 9(9)    value 0.
       01  FS1               PIC X(2).

       01  WS-EOF-CONTROL    PIC X(1) VALUE 'N'.
       01  WS-EOF-FEATURE    PIC X(1) VALUE 'N'.

       01  CONTROL-SEQ       PIC X(12).
       01  FEATURE-SEQ       PIC X(12).

       01  I                 PIC 99.
       01  CNT               PIC 9(2).
       01  CONTROL-SEQ-SZ    PIC 99.
       01  FREQ-COUNT        PIC 9(9).

       PROCEDURE DIVISION.
           PERFORM OPEN-DATA.
           PERFORM PROCESS-DATA.
           PERFORM CLOSE-DATA.
           STOP RUN.

       PROCESS-DATA.
           PERFORM READ-CONTROL-SEQ.
           PERFORM UNTIL WS-EOF-CONTROL = 'Y'
              PERFORM REWIND-FEATURE-FILE
              PERFORM FEATURE-FREQ
              PERFORM READ-CONTROL-SEQ
           END-PERFORM.
           MOVE FEATURE-FILE-KEY TO TOTAL-REG-COUNT.
           SUBTRACT 1 FROM TOTAL-REG-COUNT.
           WRITE TOTALREG-REC.

       READ-CONTROL-SEQ.
           READ CONTROL-FILE INTO CONTROL-SEQ
              AT END MOVE 'Y' TO WS-EOF-CONTROL.
           PERFORM UPDATE-CONTROL-SEQ-SZ.

       FEATURE-FREQ.
           MOVE 0 TO FREQ-COUNT.
           PERFORM READ-FEATURE-SEQ.
      *    REPEAT UNTIL END OF FEATURES
           PERFORM UNTIL WS-EOF-FEATURE = 'Y'
              PERFORM CALCULATE-FREQ-COUNT
              PERFORM READ-FEATURE-SEQ
           END-PERFORM.
           PERFORM WRITE-OUTPUT.

       WRITE-OUTPUT.
           MOVE CONTROL-SEQ TO OUT-SEQ.
           MOVE FREQ-COUNT TO OUT-FREQ.
           WRITE OUT-REC.

       READ-FEATURE-SEQ.
           ADD 1 TO FEATURE-FILE-KEY.
           READ FEATURE-FILE INTO FEATURE-SEQ
              INVALID KEY MOVE 'Y' TO WS-EOF-FEATURE
           END-READ.
           IF FS1 NOT = '00' THEN
              MOVE 'Y' TO WS-EOF-FEATURE
           END-IF.

       REWIND-FEATURE-FILE.
           MOVE 0 TO FEATURE-FILE-KEY.
           MOVE 'N' TO WS-EOF-FEATURE.

       CALCULATE-FREQ-COUNT.
           MOVE 0 TO CNT.
           PERFORM VARYING I FROM
            LENGTH OF FEATURE-SEQ BY -1 UNTIL I = 0
              IF CONTROL-SEQ(I:1) = '1' AND FEATURE-SEQ(I:1) = '1' THEN
                 ADD 1 TO CNT
              END-IF
           END-PERFORM.
           IF CNT = CONTROL-SEQ-SZ THEN
              ADD 1 TO FREQ-COUNT
           END-IF.

       UPDATE-CONTROL-SEQ-SZ.
      *    COUNT NUMBER OF '1's
           MOVE 0 TO CONTROL-SEQ-SZ.
           PERFORM VARYING I FROM LENGTH OF CONTROL-SEQ
              BY -1 UNTIL I = 0
              IF CONTROL-SEQ(I:1) = '1' THEN
                 ADD 1 TO CONTROL-SEQ-SZ
              END-IF
           END-PERFORM.

       OPEN-DATA.
           OPEN INPUT FEATURE-FILE.
           OPEN INPUT CONTROL-FILE.
           OPEN OUTPUT OUT-FILE.
           OPEN OUTPUT TOTALREG-FILE.

       CLOSE-DATA.
           CLOSE FEATURE-FILE.
           CLOSE CONTROL-FILE.
           CLOSE OUT-FILE.
           CLOSE TOTALREG-FILE.
