      *****************************************************************
      * Program name:    GEN1
      * Original author: JORGE JANAITE NETO
      * Date:            20210114
      *
      * Changes:
      *---------
      *
      *****************************************************************
      * GENERATE A SIMPLE OUTPUT WITH 12 RECORDS
      * EACH WITH A DIAGONAL '1'
      *
      * THIS IS USED TO MEASURE INDIVIDUAL FEATURE FREQUENCY
      * BY FTFREQ
      *
      * OUTPUT: a dataset with the PIC X(12)
      *
      * Sample OUPUT
      * 000000000001
      * 000000000010
      * 000000000100
      * (AND SO ONE...)
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.  GEN1.
       AUTHOR.      JORGE JANAITE NETO.

       ENVIRONMENT DIVISION.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT OUT-FILE ASSIGN TO OUTDATA
              ORGANIZATION IS SEQUENTIAL
              ACCESS MODE IS SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

       FD  OUT-FILE.
       01  OUT-REC.
           05 SEQ2 PIC X(12).

       WORKING-STORAGE SECTION.

       01  WS-POS            PIC 9(2)    VALUE 12.
       01  WS-OUT            PIC X(12).
       01  WS-EOF            PIC A(1)    VALUE 'N'.
       01  I                 PIC 9.

       PROCEDURE DIVISION.
           PERFORM OPEN-DATA.
           PERFORM COMBINATORY UNTIL WS-EOF = 'Y'.
           PERFORM CLOSE-DATA.
           STOP RUN.

       COMBINATORY.
           MOVE ZEROS TO WS-OUT.
           MOVE '1' TO WS-OUT(WS-POS:1).
           IF WS-POS > 1 THEN
              SUBTRACT  1 FROM WS-POS
           ELSE
              MOVE 'Y' TO WS-EOF
           END-IF.

           MOVE WS-OUT TO OUT-REC.
           WRITE OUT-REC.

       OPEN-DATA.
           OPEN OUTPUT OUT-FILE.

       CLOSE-DATA.
           CLOSE OUT-FILE.
