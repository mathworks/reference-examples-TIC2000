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
   
   FLASHA_M                : origin = 0x080002, length = 0x03DFFD	/* on-chip Flash */

PAGE 1 :

    EEPROM_Flash       : origin = 0x0BE000, length = 0x000010	/* on-chip Flash */
	FLASHN                : origin = 0x0BE011, length = 0x001FEF	/* on-chip Flash */
	
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
        RAMGS_DATA              : origin = CPU1_RAMGS_DATA_START, length = CPU1_RAMGS_DATA_LENGTH-0x000050
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

EEPROMData_RAM: origin = CPU1_RAMGS_DATA_START+CPU1_RAMGS_DATA_LENGTH-0x000050, length = 0x000050
}

SECTIONS
{
#if BOOT_FROM_FLASH
   /* Allocate program areas: */
       EEPROMdata        : LOAD = EEPROM_Flash,
                          RUN = EEPROMData_RAM,
                          LOAD_START(_eepromfuncsLoadStart),
                          LOAD_END(_eepromfuncsLoadEnd),
                          RUN_START(_eepromfuncsRunStart),
                          LOAD_SIZE(_eepromfuncsLoadSize),
                          PAGE = 1, ALIGN(8)
   .cinit              : > FLASHA_M,                     PAGE = 0, ALIGN(8)
   .pinit              : > FLASHA_M,                     PAGE = 0, ALIGN(8)
   .text               : > FLASHA_M,                     PAGE = 0, ALIGN(8)
   codestart           : > BEGIN_FLASH
   .TI.ramfunc         : LOAD = FLASHA_M,
                         RUN = RAMLS_PROG,
                         LOAD_START(_RamfuncsLoadStart),
                         LOAD_SIZE(_RamfuncsLoadSize),
                         LOAD_END(_RamfuncsLoadEnd),
                         RUN_START(_RamfuncsRunStart),
                         RUN_SIZE(_RamfuncsRunSize),
                         RUN_END(_RamfuncsRunEnd),
                         PAGE = 0, ALIGN(8)
	
	{
		-lF021_API_F2837xD_FPU32.lib
	}

   /* Initalized sections go in Flash */
   .econst             : > FLASHA_M,                      PAGE = 0, ALIGN(8)
   .switch             : > FLASHA_M,                      PAGE = 0, ALIGN(8)
   /* Allocate IQmath areas: */                          
   IQmath			   : > FLASHA_M,                     PAGE = 0, ALIGN(8)            /* Math Code */
   IQmathTables		   : > FLASHA_M,                     PAGE = 0, ALIGN(8)
   
   #ifdef CLA_BLOCK_INCLUDED
       /* CLA specific sections */
       Cla1Prog        : LOAD = FLASHA_M,
                          RUN = RAMLS_CLA_PROG,
                          LOAD_START(_Cla1funcsLoadStart),
                          LOAD_END(_Cla1funcsLoadEnd),
                          RUN_START(_Cla1funcsRunStart),
                          LOAD_SIZE(_Cla1funcsLoadSize),
                          PAGE = 0, ALIGN(8)
       .ebss            : > RAMGS_DATA ,                 PAGE = 1
   #else
       .ebss            : >> RAMGS_DATA | RAMLS_DATA,    PAGE = 1 
   #endif //CLA_BLOCK_INCLUDED
#else
   codestart            : > BEGIN_FLASH,                 PAGE = 0
   .TI.ramfunc             : > RAMLS_PROG                PAGE = 0
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
   .cio                 : > RAMGS_DATA,                  PAGE = 1

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
       .const_cla	    :  LOAD = FLASHA_M,
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
