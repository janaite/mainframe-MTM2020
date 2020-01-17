//*********************************************************************
//*  COMBINE THE MOST POPULAR FEATURES INTO NEXT GROUP
//*
//* INPUT: GEN, NXTGEN, PRFCBRRD, PRFDSCMB
//*********************************************************************
//PREPCOMB PROC
//*
//STEP01   EXEC RMPROC,DSNME=&PRFDSCMB..G&NXTGEN.
//*
//STEP02   EXEC PGM=CBITEM,PARM=&GEN.
//STEPLIB  DD DSN=&SYSUID..MTM20.LOAD,DISP=SHR
//COMBDATA DD DSN=&PRFCBRRD..G&GEN.,DISP=SHR
//OUTDATA  DD DSN=&PRFDSCMB..G&NXTGEN.,
//            DISP=(NEW,CATLG,DELETE),
//            SPACE=(12,(1000,500)),AVGREC=U,
//            DCB=(DSORG=PS,RECFM=F,LRECL=12)
//*
//         PEND
