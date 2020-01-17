//*********************************************************************
//* FREQUENCY MEASURE OF INDIVIDUAL FEATURES
//*
//* INPUT: GEN, PRFDSCOMB, PRFDSFQ1, DSFT
//*********************************************************************
//FTFQ     PROC
//*
//STEP01   EXEC RMPROC,DSNME=&PRFDSFQ1..G&GEN.
//*
//STEP02   EXEC PGM=FTFREQ,PARM=&GEN.
//STEPLIB  DD DSN=&SYSUID..MTM20.LOAD,DISP=SHR
//SYSPRINT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//FEATDATA DD DSN=&DSFT.,DISP=SHR
//CNTLDATA DD DSN=&PRFDSCMB..G&GEN.,DISP=SHR
//OUTDATA  DD DSN=&PRFDSFQ1..G&GEN.,
//            DISP=(NEW,CATLG,DELETE),
//            SPACE=(21,(20,10)),AVGREC=U,
//            DCB=(DSORG=PS,RECFM=F,LRECL=21)
//TOTALREG DD DUMMY
//         PEND
