//*********************************************************************
//* FREQUENCY MEASURE OF INDIVIDUAL FEATURES (WITH TOTALCOUNT)
//*
//* INPUT: GEN, PRFDSCOMB, PRFDSFQ1, DSFT, DSTOTAL
//*********************************************************************
//FTFQ0    PROC
//*
//STEP01   EXEC RMPROC,DSNME=&PRFDSFQ1..G&GEN.
//*
//STEP02   EXEC RMPROC,DSNME=&DSTOTAL.
//*
//STEP03   EXEC PGM=FTFREQ,PARM=&GEN.
//STEPLIB  DD DSN=&SYSUID..MTM20.LOAD,DISP=SHR
//SYSPRINT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//FEATDATA DD DSN=&DSFT.,DISP=SHR
//CNTLDATA DD DSN=&PRFDSCMB..G&GEN.,DISP=SHR
//OUTDATA  DD DSN=&PRFDSFQ1..G&GEN.,
//            DISP=(NEW,CATLG,DELETE),
//            SPACE=(21,(20,10)),AVGREC=U,
//            DCB=(DSORG=PS,RECFM=F,LRECL=21)
//TOTALREG DD DSN=&DSTOTAL.,
//            DISP=(NEW,CATLG,DELETE),
//            SPACE=(9,(1,1)),AVGREC=U,
//            DCB=(DSORG=PS,RECFM=F,LRECL=9)
//         PEND
