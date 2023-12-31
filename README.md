# CycleLightning
A generic template script for cycle consistency training using pytorch lightning and the transformers library. The script trains each model on the output of the other iteratively. 

`WARNING`: This script has only been tested on LLaMA, GPT2 and T5. If you find any irregularities, please open an issue and I will take a look when I can.

`WARNING`: This script has not been tested on multi-GPU setups.

## Project Setup

Required libraries can be installed using the `requirements.txt` file with pip, conda or your other favourite package manager.

## Training

The script currently only supports models A and B being the same*. The two current supported generation types are causal and seq2seq.

```bash
# Causal example
python train.py --model_name_or_path gpt2 --task causal_lm

# Seq2Seq example
python train.py --model_name_or_path t5-small --task seq2seq_lm
```

All script arguments can be found with:
```bash
python train.py --help
```

\* This may change in the future to allow e.g. model A to be causal and model B to be seq2seq.

## Data Format

Datasets A and B can be imported in the same or different formats, e.g. both in json or one in json and one in DatasetDict.

Datasets can be mismatched in size and can optionally have a validation split. Data will be interleaved until the smaller dataset is cully consumed, after which only the larger dataset will be used for training. This constitues one complete epoch. 

You can pass any directories/files you want for datasets A or B but recommended best practice is as follows:

```
data
|
project_name e.g. CycleNER
|
└───split_a_name e.g. Sentences
|    |  files/directories
|
└───split_b_name e.g. EntitySequences
     |   files/directories
```

See `data/example` as an example for DatasetDict.

### JSON & JSONL
Only allows for training data, no validation data can be supplied. If you want to use validation data, please use one of the other listed formats.
```json
[
    {"text": "this is some text"},
    {"text": "this is some other text"}
]
```

```json
{"text": "this is some text"}
{"text": "this is some other text"}
```

### DatasetDict
Can optionally contain a validation split for datasets A and/or B.

```python
DatasetDict({
    train: Dataset({
        features: ['text'],
        num_rows: L
    }),
    validation: Dataset({
        features: ['text', 'label'],
        num_rows: M
    })
    test: Dataset({
        features: ['text', 'label'],
        num_rows: N
    })
})
```

## Quantisation and PEFT

There is inbuilt integration with BitsAndBytes and LoRA modules. To enable LoRA, set the `full_finetune` flag to be false and set `bits` flag to 4 or 8 for 4- or 8-bit quantisation respectively. e.g.

```bash
python train.py --model_name_or_path <path to llama weights> --task 'causal_lm' --full_finetune False --bits 4
```

All LoRA parameters can be controlled through command line arguments.

Automatically extracting the layers to add LoRA modules to is not 100% working e.g. for both GPT and T5. You can manually specify the layers to add LoRA modules to with a flag set in the following way:

```bash
# E.g. for T5
--modules o v q wi_0 wi_1 # etc.
```