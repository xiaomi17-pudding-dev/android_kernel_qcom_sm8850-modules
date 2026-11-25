/* SPDX-License-Identifier: GPL-2.0 */
/*
 * cs_dsp interfaces the CS35L43 driver uses beyond the common cs_dsp API
 */
#ifndef CS_DSP_EXT_H
#define CS_DSP_EXT_H

struct cs_dsp;
struct firmware;

int cs_dsp_load_coeff(struct cs_dsp *dsp, const struct firmware *firmware,
		      const char *file);

#endif /* CS_DSP_EXT_H */
