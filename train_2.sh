python train.py \
    --model_name_or_path t5-small \
    --task seq2seq_lm \
    --data_a data/conll2003/A \
    --data_b data/conll2003/B \
    --output_dir models/CycleNER \
    --use_wandb \
    --wandb_project cycle-lightning-ner \
    --wandb_run_name test1-causal \
    --train_batch_size 1 \
    --eval_batch_size 1 \
    --lr_a 3e-4 \
    --lr_b 3e-4 \
    --full_finetune False \
    --bits 4 \
    --modules o v
