/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0xfbc00daa */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "/home/ise/ise_projs/T4/T4_proj4/t4proj4/Top_Level_tb.vhd";



static void work_a_2522137388_2372691052_p_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    int64 t7;
    int64 t8;

LAB0:    t1 = (t0 + 2624U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(36, ng0);
    t2 = (t0 + 3272);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(37, ng0);
    t2 = (t0 + 1648U);
    t3 = *((char **)t2);
    t7 = *((int64 *)t3);
    t8 = (t7 / 2);
    t2 = (t0 + 2432);
    xsi_process_wait(t2, t8);

LAB6:    *((char **)t1) = &&LAB7;

LAB1:    return;
LAB4:    xsi_set_current_line(38, ng0);
    t2 = (t0 + 3272);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(39, ng0);
    t2 = (t0 + 1648U);
    t3 = *((char **)t2);
    t7 = *((int64 *)t3);
    t8 = (t7 / 2);
    t2 = (t0 + 2432);
    xsi_process_wait(t2, t8);

LAB10:    *((char **)t1) = &&LAB11;
    goto LAB1;

LAB5:    goto LAB4;

LAB7:    goto LAB5;

LAB8:    goto LAB2;

LAB9:    goto LAB8;

LAB11:    goto LAB9;

}

static void work_a_2522137388_2372691052_p_1(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    int64 t7;
    int64 t8;
    int64 t9;
    char *t10;
    unsigned char t11;
    unsigned char t12;
    char *t13;

LAB0:    t1 = (t0 + 2872U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(48, ng0);
    t2 = (t0 + 3336);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(49, ng0);
    t7 = (100 * 1000LL);
    t2 = (t0 + 2680);
    xsi_process_wait(t2, t7);

LAB6:    *((char **)t1) = &&LAB7;

LAB1:    return;
LAB4:    xsi_set_current_line(52, ng0);
    t2 = (t0 + 3336);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(56, ng0);
    t7 = (500 * 1000000LL);
    t2 = (t0 + 2680);
    xsi_process_wait(t2, t7);

LAB10:    t3 = (t0 + 3192);
    *((int *)t3) = 1;
    *((char **)t1) = &&LAB11;
    goto LAB1;

LAB5:    goto LAB4;

LAB7:    goto LAB5;

LAB8:    t6 = (t0 + 3192);
    *((int *)t6) = 0;
    t13 = (t0 + 2680);
    xsi_process_ignore_timeout(t13);
    xsi_set_current_line(59, ng0);
    t2 = (t0 + 1352U);
    t3 = *((char **)t2);
    t11 = *((unsigned char *)t3);
    t12 = (t11 == (unsigned char)3);
    if (t12 != 0)
        goto LAB12;

LAB14:    xsi_set_current_line(64, ng0);
    t7 = (100 * 1000LL);
    t2 = (t0 + 2680);
    xsi_process_wait(t2, t7);

LAB21:    *((char **)t1) = &&LAB22;
    goto LAB1;

LAB9:    t6 = (t0 + 1352U);
    t10 = *((char **)t6);
    t11 = *((unsigned char *)t10);
    t12 = (t11 == (unsigned char)3);
    if (t12 == 1)
        goto LAB8;
    else
        goto LAB10;

LAB11:    t4 = (t0 + 2680);
    t5 = (t4 + 208U);
    t8 = *((int64 *)t5);
    t9 = xsi_get_sim_current_time();
    if (t8 == t9)
        goto LAB8;
    else
        goto LAB9;

LAB12:    xsi_set_current_line(61, ng0);
    t7 = (100 * 1000LL);
    t2 = (t0 + 2680);
    xsi_process_wait(t2, t7);

LAB17:    *((char **)t1) = &&LAB18;
    goto LAB1;

LAB13:    xsi_set_current_line(67, ng0);

LAB25:    *((char **)t1) = &&LAB26;
    goto LAB1;

LAB15:    goto LAB13;

LAB16:    goto LAB15;

LAB18:    goto LAB16;

LAB19:    goto LAB13;

LAB20:    goto LAB19;

LAB22:    goto LAB20;

LAB23:    goto LAB2;

LAB24:    goto LAB23;

LAB26:    goto LAB24;

}


extern void work_a_2522137388_2372691052_init()
{
	static char *pe[] = {(void *)work_a_2522137388_2372691052_p_0,(void *)work_a_2522137388_2372691052_p_1};
	xsi_register_didat("work_a_2522137388_2372691052", "isim/Top_Level_tb_isim_beh.exe.sim/work/a_2522137388_2372691052.didat");
	xsi_register_executes(pe);
}
