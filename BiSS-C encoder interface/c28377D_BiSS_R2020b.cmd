#include "MW_F2837xD_MemoryMap.h"
#ifdef CLA_BLOCK_INCLUDED
// Define a size for the CLA scratchpad area that will be used
// by the CLA compiler for local symbols and temps
// Also force references to the special symbols that mark the
// scratchpad are. 
CLA_SCRATCHPAD_SIZE = 0x100;
--undef_sym=__cla_scratchpad_end
--undef_sym=__cla_scratchpad_start
#endif //CLA_BLOCK_INCLUDED
MEMORY
{
PAGE 0 :
   /* BEGIN is used for the "boot to SARAM" bootloader mode   */
   BEGIN           	            : origin = 0x000000, length = 0x000002
   BEGIN_FLASH     	            : origin = 0x080000, length = 0x000002
   #ifdef CLA_BLOCK_INCLUDED
        RAMLS_PROG      	    : origin = 0x008000, length = 0x001800
        RAMLS_CLA_PROG          : origin = 0x00A800, length = 0x000800
   #else
        #if BOOT_FROM_FLASH
            RAMLS_PROG      	: origin = 0x008000, length = 0x002000
        #else
            RAMLS_PROG      	: origin = 0x008000, length = 0x003000
        #endif //BOOT_FROM_FLASH
   #endif //CLA_BLOCK_INCLUDED
   
   #ifdef CPU1       
        #if (CPU1_RAMGS_PROG_LENGTH > 0)
            RAMGS_PROG          : origin = CPU1_RAMGS_PROG_START, length = CPU1_RAMGS_PROG_LENGTH
        #endif //(CPU1_RAMGS_PROG_LENGTH > 0)
   #else
        #if (CPU2_RAMGS_PROG_LENGTH > 0)
            RAMGS_PROG          : origin = CPU2_RAMGS_PROG_START, length = CPU2_RAMGS_PROG_LENGTH
       #endif //(CPU2_RAMGS_PROG_LENGTH > 0)
   #endif //CPU1

   RESET           	            : origin = 0x3FFFC0, length = 0x000002
   /* Flash sectors */
   #if defined(F28376D) || defined(F28374D)
        FLASHA_N                : origin = 0x080002, length = 0x01FFFE	/* on-chip Flash */ 
   #else                        
        FLASHA_N                : origin = 0x080002, length = 0x03FFFE	/* on-chip Flash */ 
   #endif //defined(F28376D) || defined(F28374D)

PAGE 1 :
   #ifdef CPU1
       BOOT_RSVD                : origin = 0x000002, length = 0x000120     /* Part of M0, BOOT rom will use this for stack */
   #else                        
       BOOT_RSVD                : origin = 0x000002, length = 0x00007E     /* Part of M0, BOOT rom will use this for stack */
   #endif //CPU1

   #ifdef CPU1
       RAMM0M1           	    : origin = 0x000122, length = 0x0006DE
   #else                        
       RAMM0M1           	    : origin = 0x000080, length = 0x000780
   #endif //CPU1

   RAMD0D1           	        : origin = 0x00B000, length = 0x001000

   #ifdef CLA_BLOCK_INCLUDED
        RAMLS_CLA_DATA          : origin = 0x009800, length = 0x001000
   #else
        #if BOOT_FROM_FLASH
            RAMLS_DATA          : origin = 0x00A000, length = 0x001000
        #endif //BOOT_FROM_FLASH
   #endif //CLA_BLOCK_INCLUDED

#ifdef CPU1       
        RAMGS_DATA              : origin = CPU1_RAMGS_DATA_START, length = CPU1_RAMGS_DATA_LENGTH
#else                           
        RAMGS_DATA              : origin = CPU2_RAMGS_DATA_START, length = CPU2_RAMGS_DATA_LENGTH
#endif //CPU1

   RAMGS_IPCBuffCPU1            : origin = 0x00C000, length = 0x001000
   RAMGS_IPCBuffCPU2            : origin = 0x00D000, length = 0x001000 
                                
   CLA1_MSGRAMLOW               : origin = 0x001480, length = 0x000080
   CLA1_MSGRAMHIGH              : origin = 0x001500, length = 0x000080
                                
   CPU2TOCPU1RAM                : origin = 0x03F800, length = 0x000400
   CPU1TOCPU2RAM                : origin = 0x03FC00, length = 0x000400

#ifdef EMIF1_CS0_INCLUDED
   EMIF1_CS0_MEMORY             : origin = 0x80000000, length = 0x10000000
#endif //EMIF1_CS0_INCLUDED
#ifdef EMIF1_CS2_INCLUDED
   EMIF1_CS2_MEMORY             : origin = 0x00100000, length = 0x00200000
#endif //EMIF1_CS2_INCLUDED
#ifdef EMIF1_CS3_INCLUDED
   EMIF1_CS3_MEMORY             : origin = 0x00300000, length = 0x00080000
#endif //EMIF1_CS3_INCLUDED
#ifdef EMIF1_CS4_INCLUDED
   EMIF1_CS4_MEMORY             : origin = 0x00380000, length = 0x00060000
#endif //EMIF1_CS4_INCLUDED
#ifdef EMIF2_CS0_INCLUDED
   EMIF2_CS0_MEMORY             : origin = 0x90000000, length = 0x10000000
#endif //EMIF2_CS0_INCLUDED
#ifdef EMIF2_CS2_INCLUDED
   EMIF2_CS2_MEMORY             : origin = 0x00002000, length = 0x00001000
#endif //EMIF2_CS2_INCLUDED

CLB1_LOGICCFG      : origin = 0x003000, length = 0x000040
CLB1_LOGICCTL      : origin = 0x003100, length = 0x000040
CLB1_DATAXCHG      : origin = 0x003200, length = 0x000200
CLB2_LOGICCFG      : origin = 0x003400, length = 0x000040
CLB2_LOGICCTL      : origin = 0x003500, length = 0x000040
CLB2_DATAXCHG      : origin = 0x003600, length = 0x000200
CLB3_LOGICCFG      : origin = 0x003800, length = 0x000040
CLB3_LOGICCTL      : origin = 0x003900, length = 0x000040
CLB3_DATAXCHG      : origin = 0x003A00, length = 0x000200
CLB4_LOGICCFG      : origin = 0x003C00, length = 0x000040
CLB4_LOGICCTL      : origin = 0x003D00, length = 0x000040
CLB4_DATAXCHG      : origin = 0x003E00, length = 0x000200

}

SECTIONS
{
#if BOOT_FROM_FLASH
   /* Allocate program areas: */
   .cinit              : > FLASHA_N                      PAGE = 0, ALIGN(4)
   .pinit              : > FLASHA_N,                     PAGE = 0, ALIGN(4)
   .text               : > FLASHA_N                      PAGE = 0, ALIGN(4)
   codestart           : > BEGIN_FLASH                   PAGE = 0, ALIGN(4)
   ramfuncs            : LOAD = FLASHA_N,
                         RUN = RAMLS_PROG,
                         LOAD_START(_RamfuncsLoadStart),
                         LOAD_SIZE(_RamfuncsLoadSize),
                         LOAD_END(_RamfuncsLoadEnd),
                         RUN_START(_RamfuncsRunStart),
                         RUN_SIZE(_RamfuncsRunSize),
                         RUN_END(_RamfuncsRunEnd),
                         PAGE = 0, ALIGN(4)
   /* Initalized sections go in Flash */
   .econst             : > FLASHA_N                      PAGE = 0, ALIGN(4)
   .switch             : > FLASHA_N                      PAGE = 0, ALIGN(4)
   /* Allocate IQmath areas: */                          
   IQmath			   : > FLASHA_N,                     PAGE = 0, ALIGN(4)            /* Math Code */
   IQmathTables		   : > FLASHA_N,                     PAGE = 0, ALIGN(4)
   
   #ifdef CLA_BLOCK_INCLUDED
       /* CLA specific sections */
       Cla1Prog        : LOAD = FLASHA_N,
                          RUN = RAMLS_CLA_PROG,
                          LOAD_START(_Cla1funcsLoadStart),
                          LOAD_END(_Cla1funcsLoadEnd),
                          RUN_START(_Cla1funcsRunStart),
                          LOAD_SIZE(_Cla1funcsLoadSize),
                          PAGE = 0, ALIGN(4)
       .ebss            : > RAMGS_DATA ,                 PAGE = 1
   #else
       .ebss            : >> RAMGS_DATA | RAMLS_DATA,    PAGE = 1 
   #endif //CLA_BLOCK_INCLUDED
   
#else
   codestart            : > BEGIN,                       PAGE = 0
   ramfuncs             : > RAMLS_PROG                   PAGE = 0
   .cinit               : > RAMLS_PROG                   PAGE = 0
   .pinit               : > RAMLS_PROG                   PAGE = 0
   .switch              : > RAMLS_PROG                   PAGE = 0
   .econst              : > RAMLS_PROG                   PAGE = 0
   /* Allocate IQ math areas: */
   IQmath			    : > RAMLS_PROG,                  PAGE = 0            /* Math Code */
   IQmathTables		    : > RAMLS_PROG,                  PAGE = 0

   #ifdef CLA_BLOCK_INCLUDED
       /* CLA specific sections */
       Cla1Prog         : > RAMLS_CLA_PROG,              PAGE = 0
   #endif //CLA_BLOCK_INCLUDED
   .text                : >> RAMLS_PROG | RAMGS_PROG,    PAGE = 0

   .ebss                : > RAMGS_DATA ,                 PAGE = 1
 #endif //BOOT_FROM_FLASH

   .stack               : > RAMM0M1,                     PAGE = 1
   .reset               : > RESET,                       PAGE = 0, TYPE = DSECT /* not used, */
   .esysmem             : > RAMD0D1,                     PAGE = 1
   .cio                 : > RAMLS_PROG,                  PAGE = 0

   #if defined(EMIF1_CS0_INCLUDED) && defined(EMIF2_CS0_INCLUDED)
      .farbss           : > EMIF1_CS0_MEMORY | EMIF2_CS0_MEMORY,      PAGE = 1
      .farconst         : > EMIF1_CS0_MEMORY | EMIF2_CS0_MEMORY,      PAGE = 1
   #elif !defined(EMIF1_CS0_INCLUDED) && defined(EMIF2_CS0_INCLUDED)
      .farbss           : > EMIF2_CS0_MEMORY,            PAGE = 1
      .farconst         : > EMIF2_CS0_MEMORY,            PAGE = 1
   #elif defined(EMIF1_CS0_INCLUDED) && !defined(EMIF2_CS0_INCLUDED)
      .farbss           : > EMIF1_CS0_MEMORY,            PAGE = 1
      .farconst         : > EMIF1_CS0_MEMORY,            PAGE = 1
   #else
      //No EMIF memory sections
   #endif //defined(EMIF1_CS0_INCLUDED) && defined(EMIF2_CS0_INCLUDED)

   #ifdef EMIF1_CS0_INCLUDED
      Em1Cs0            : > EMIF1_CS0_MEMORY,            PAGE = 1
   #endif //EMIF1_CS0_INCLUDED                           
   #ifdef EMIF2_CS0_INCLUDED                             
       Em2Cs0           : > EMIF2_CS0_MEMORY,            PAGE = 1
   #endif //EMIF2_CS0_INCLUDED                           
   #ifdef EMIF1_CS2_INCLUDED                             
       Em1Cs2           : > EMIF1_CS2_MEMORY,            PAGE = 1
   #endif //EMIF1_CS2_INCLUDED                           
   #ifdef EMIF1_CS3_INCLUDED                             
       Em1Cs3           : > EMIF1_CS3_MEMORY,            PAGE = 1
   #endif //EMIF1_CS3_INCLUDED                           
   #ifdef EMIF1_CS4_INCLUDED                             
       Em1Cs4           : > EMIF1_CS4_MEMORY,            PAGE = 1
   #endif //EMIF1_CS4_INCLUDED                           
   #ifdef MW_EMIF2_CS2_INCLUDED                          
       Em2Cs2           : > EMIF2_CS2_MEMORY,            PAGE = 1
   #endif //MW_EMIF2_CS2_INCLUDED
   
   Clb1LogicCfgRegsFile	: > CLB1_LOGICCFG,	PAGE = 1
   Clb1LogicCtrlRegsFile : > CLB1_LOGICCTL,	PAGE = 1
   Clb1DataExchgRegsFile : > CLB1_DATAXCHG,	PAGE = 1
   Clb2LogicCfgRegsFile : > CLB2_LOGICCFG,	PAGE = 1
   Clb2LogicCtrlRegsFile : > CLB2_LOGICCTL,	PAGE = 1
   Clb2DataExchgRegsFile : > CLB2_DATAXCHG,	PAGE = 1
   Clb3LogicCfgRegsFile : > CLB3_LOGICCFG,	PAGE = 1
   Clb3LogicCtrlRegsFile : > CLB3_LOGICCTL,	PAGE = 1
   Clb3DataExchgRegsFile : > CLB3_DATAXCHG,	PAGE = 1
   Clb4LogicCfgRegsFile : > CLB4_LOGICCFG,	PAGE = 1
   Clb4LogicCtrlRegsFile : > CLB4_LOGICCTL,	PAGE = 1
   Clb4DataExchgRegsFile : > CLB4_DATAXCHG,	PAGE = 1
   
   #ifdef CLA_BLOCK_INCLUDED
       /* CLA C compiler sections */
       //
       // Must be allocated to memory the CLA has write access to
       //
       Cla1DataRam0		: > RAMLS_CLA_DATA,              PAGE=1

       Cla1ToCpuMsgRAM  : > CLA1_MSGRAMLOW,              PAGE = 1
       CpuToCla1MsgRAM  : > CLA1_MSGRAMHIGH,             PAGE = 1
       CLAscratch       :
                         { *.obj(CLAscratch)
                         . += CLA_SCRATCHPAD_SIZE;
                         *.obj(CLAscratch_end) } >  RAMLS_CLA_DATA,  PAGE = 1

       .scratchpad      : > RAMLS_CLA_DATA,              PAGE = 1
       .bss_cla		    : > RAMLS_CLA_DATA,              PAGE = 1
       .const_cla	    :  LOAD = FLASHA_N,
                           RUN = RAMLS_CLA_DATA,
                           RUN_START(_Cla1ConstRunStart),
                           LOAD_START(_Cla1ConstLoadStart),
                           LOAD_SIZE(_Cla1ConstLoadSize),
                           PAGE = 1
   #endif //CLA_BLOCK_INCLUDED

   #ifdef CPU1  
       /* The following section definitions are required when using the IPC API Drivers */ 
        GROUP           : > CPU1TOCPU2RAM,               PAGE = 1 
        {
            PUTBUFFER 
            PUTWRITEIDX 
            GETREADIDX 
            WRITEFLAG1CPU1
	        WRITEFLAG2CPU1
            READFLAG1CPU1
            READFLAG2CPU1
        }
        GROUP           : > CPU2TOCPU1RAM,               PAGE = 1
        {
            GETBUFFER :    TYPE = DSECT
            GETWRITEIDX :  TYPE = DSECT
            PUTREADIDX :   TYPE = DSECT
            WRITEFLAG1CPU2: TYPE = DSECT
            WRITEFLAG2CPU2: TYPE = DSECT
            READFLAG1CPU2:  TYPE = DSECT
            READFLAG2CPU2:  TYPE = DSECT
        }

   #else
       /* The following section definitions are required when using the IPC API Drivers */ 
        GROUP           : > CPU2TOCPU1RAM,               PAGE = 1 
        {
            PUTBUFFER 
            PUTWRITEIDX 
            GETREADIDX 
            WRITEFLAG1CPU2
            WRITEFLAG2CPU2
            READFLAG1CPU2			
            READFLAG2CPU2			
        }
        GROUP           : > CPU1TOCPU2RAM,               PAGE = 1
        {
            GETBUFFER :    TYPE = DSECT
            GETWRITEIDX :  TYPE = DSECT
            PUTREADIDX :   TYPE = DSECT
            WRITEFLAG1CPU1: TYPE = DSECT
            WRITEFLAG2CPU1: TYPE = DSECT
            READFLAG1CPU1 : TYPE = DSECT
            READFLAG2CPU1 : TYPE = DSECT
        }
   #endif //CPU1
        GROUP           : > RAMGS_IPCBuffCPU1,           PAGE = 1 
        {
            CPU1TOCPU2GSRAM
        }
        GROUP           : > RAMGS_IPCBuffCPU2,           PAGE = 1 
        {
            CPU2TOCPU1GSRAM
        }
}

/*
//===========================================================================
// End of file.
//===========================================================================
*/
