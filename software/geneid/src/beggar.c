/*************************************************************************
*                                                                        *
*   Module: beggar                                                       *
*                                                                        *
*   Estimate the memory needed to run memory (current configuration)     *
*                                                                        *
*   This file is part of the geneid 1.1 distribution                     *
*                                                                        *
*     Copyright (C) 2001 - Enrique BLANCO GARCIA                         *
*                          Roderic GUIGO SERRA                           * 
*                                                                        *
*  This program is free software; you can redistribute it and/or modify  *
*  it under the terms of the GNU General Public License as published by  *
*  the Free Software Foundation; either version 2 of the License, or     *
*  (at your option) any later version.                                   *
*                                                                        *
*  This program is distributed in the hope that it will be useful,       *
*  but WITHOUT ANY WARRANTY; without even the implied warranty of        *
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
*  GNU General Public License for more details.                          *
*                                                                        *
*  You should have received a copy of the GNU General Public License     *
*  along with this program; if not, write to the Free Software           * 
*  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.             *
*************************************************************************/

/*  $Id: beggar.c,v 1.1 2001-12-18 16:19:57 eblanco Exp $  */

/* Estimation values */
#define AVG_DIM   15
#define AVG_ORDER  3
#define OLIGO_DIM  5


#include "geneid.h"

extern long NUMSITES, NUMEXONS, MAXBACKUPSITES, MAXBACKUPEXONS;

/* Computing the memory required to execute geneid */
void beggar(long L)
{
  long memTotal;
  long memSites;
  long memExons;
  long memEvi;
  long memSR;
  long memGC;
  long memGenes;
  long memParams;
  long memSequence;
  long memBackup;

  /* packSites: +/- */

  memSites = STRANDS * (sizeof(struct s_packSites) +
						(4 * NUMSITES * sizeof(struct s_site)));

  /* packExons: +/- */
  memExons = STRANDS * (sizeof(struct s_packExons) +
						((NUMEXONS/RFIRST + NUMEXONS/RINTER +
						  NUMEXONS/RTERMI + NUMEXONS/RSINGL) *
						 sizeof(exonGFF)));
  /* Sort exons */
  memExons += NUMEXONS * FSORT * sizeof(exonGFF);

  /* Evidences */
  memEvi = (MAXEVIDENCES * sizeof(exonGFF)) +
	(3*MAXEVIDENCES * sizeof(struct s_site));

  /* SRs */
  memSR =  sizeof(struct s_packSR) +
	(STRANDS * FRAMES * MAXSR * sizeof(SR));

  /* G+C INFO */
  memGC = 2 * LENGTHSi * sizeof(long);

  /* pack Genes: ghost, Ga, d, km-jm */
  memGenes = sizeof(struct s_packGenes) +
	2 * (sizeof(exonGFF) + 2 * sizeof(struct s_site)) +
	MAXENTRY * FRAMES * sizeof(exonGFF*) +
	MAXENTRY * (2 * NUMEXONS) * sizeof(exonGFF*) +
	2 * MAXENTRY * sizeof(long);

  /* Statistical model: profiles, Markov model, Markov tmp, exon values,  */
  /* isochores and gene model */
  memParams = (4 * (sizeof(profile) + AVG_DIM * AVG_ORDER * sizeof(float))) 
	+ (6 * OLIGO_DIM * sizeof(float)) 
	+ (6 * LENGTHSi * sizeof(float)) 
	+ (4 * sizeof(paramexons));

  memParams += MAXISOCHORES * sizeof(gparam *);
  memParams = memParams * MAXISOCHORES;

  memParams += sizeof(dict) + 2*MAXENTRY* sizeof(int) +
	2*MAXENTRY* sizeof(long);
            
  /* Backup operations */
  memBackup = sizeof(struct s_packDump) + MAXBACKUPSITES * sizeof(struct s_site)
	+ MAXBACKUPEXONS * sizeof(exonGFF) + sizeof(struct s_dumpHash)
	+ ((MAXBACKUPEXONS / HASHFACTOR) * sizeof(dumpNode*));

  /* Sequence space */
  memSequence = L * sizeof(char);


  memTotal = 
	memSites +
	memExons +
	memEvi +
	memSR +
	memGC +
	memGenes +
	memParams +
	memSequence +
	memBackup;


  /* Display numbers */

  printf("AMOUNT of MEMORY required by current geneid configuration\n");
  printf("---------------------------------------------------------\n\n");

  printf("Sites\t\t\t: %f Mb\n",(float)memSites/(float)MEGABYTE);
  printf("Exons\t\t\t: %f Mb\n",(float)memExons/(float)MEGABYTE);
  printf("Evidences\t\t: %f Mb\n",(float)memEvi/(float)MEGABYTE);
  printf("Homology\t\t: %f Mb\n",(float)memSR/(float)MEGABYTE);
  printf("G+C info\t\t: %f Mb\n",(float)memGC/(float)MEGABYTE);
  printf("Genes\t\t\t: %f Mb\n",(float)memGenes/(float)MEGABYTE);
  printf("Statistical model\t: %f Mb\n",(float)memParams/(float)MEGABYTE);
  printf("Backup operations\t: %f Mb\n",(float)memBackup/(float)MEGABYTE);
  printf("Input sequence\t\t: %f Mb\n",(float)memSequence/(float)MEGABYTE);

  printf("---------------------------------------------------------\n\n");
  printf("TOTAL AMOUNT\t\t: %f Mb\n",(float)memTotal/(float)MEGABYTE);

  exit(0);
}









