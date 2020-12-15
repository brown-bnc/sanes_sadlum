#!/bin/bash
#SBATCH -N 1
#SBATCH -c 8
#SBATCH --mem=30G
#SBATCH --time 18:00:00
#SBATCH -J fmriprep
#SBATCH -o /gpfs/scratch/%u/logs/xnat2bids-%j.out
#SBATCH --array=135

# Your working directory in Oscar, usually /gpfs/data/<your PI's group>.
# We pass (bind) this path to singularity so that it can access/see it
data_dir=/gpfs/data/bnc
investigator=sanes
study_label=sadlum

# Output directory
# It has to be under the data_dir, otherwise it won't be seen by singularity
root_dir=${data_dir}/shared/bids-export/${USER}
output_dir=${root_dir}/${investigator}/study-${study_label}

participant_label=${SLURM_ARRAY_TASK_ID}
fmriprep_version=20.1.2

# to run fMRIPrep without freesurfer option

singularity run --cleanenv  --contain \
--bind ${output_dir}:/data:ro \
--bind /gpfs/scratch/${USER}:/scratch \
--bind /gpfs/data/bnc/licenses:/licenses:ro \
/gpfs/data/bnc/simgs/poldracklab/fmriprep-${fmriprep_version}.sif  \
/data/bids /data/bids/derivatives/fmriprep-${fmriprep_version}-nofs \
participant --participant-label ${participant_label}                 \
--fs-license-file /licenses/freesurfer-license.txt --fs-no-reconall   \
-w /scratch/fmriprep --stop-on-first-crash                            \
--omp-nthreads 16 --nthreads 16
