//*********************************************************************
//* PREPARE FREQUENCY ALREADY PRUNNED TO BE USED IN CBITEM
//*
//* INPUT: GEN, PRFCBRRD, PRFDSFQ2
//*********************************************************************
//PREPCOMB PROC
//*
//*********************************************************************
//* GENERATE RDDS FROM G1 (FOR USE IT WITH CBITEM)
//*********************************************************************
//*
//STEP01   EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *,SYMBOLS=EXECSYS
  DELETE   &PRFCBRRD..G&GEN.
  SET      MAXCC = 0
  DEFINE   CLUSTER  (NAME(&PRFCBRRD..G&GEN.)  -
                    VOLUMES(VPWRKE)  -
                    TRACKS(2,1)      -
                    RECORDSIZE(21 21)  -
                    REUSE -
                    FREESPACE(3 3)   -
                    NUMBERED)        -
           DATA     (NAME(&PRFCBRRD..G&GEN..DATA))
/*
//*********************************************************************
//* IMPORT DATA INTO RRDS G1
//*********************************************************************
//STEP02   EXEC PGM=IDCAMS
//SYSPRINT DD   SYSOUT=*
//SYSOUT   DD   SYSOUT=*
//DD1      DD   DSNAME=&PRFDSFQ2..G&GEN.,DISP=SHR
//DD2      DD   DSNAME=&PRFCBRRD..G&GEN.,DISP=OLD
//SYSIN    DD   *
  REPRO -
      INFILE(DD1) -
      OUTFILE(DD2)
/*
//*
//         PEND
