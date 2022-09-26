#FROM public.ecr.aws/lambda/provided:al2
#RUN yum update && yum install python3-pip
FROM public.ecr.aws/lambda/python:3.8

# Create app directory
WORKDIR ${LAMBDA_TASK_ROOT}

#Pull Down Code
RUN curl -k -o ${LAMBDA_TASK_ROOT}/app.py https://raw.githubusercontent.com/GDIT-MissionAI/huggingface-summarization/main/huggingface-summarization.py

#handle the loading of the models.
RUN mkdir sshleifer
RUN mkdir sshleifer/distilbart-cnn-12-6
RUN curl -L https://huggingface.co/sshleifer/distilbart-cnn-12-6/raw/main/config.json -o ./sshleifer/distilbart-cnn-12-6/config.json
RUN curl -L https://huggingface.co/sshleifer/distilbart-cnn-12-6/resolve/main/flax_model.msgpack -o ./sshleifer/distilbart-cnn-12-6/flax_model.msgpack
RUN curl -L https://huggingface.co/sshleifer/distilbart-cnn-12-6/raw/main/merges.txt -o ./sshleifer/distilbart-cnn-12-6/merges.txt
RUN curl -L https://huggingface.co/sshleifer/distilbart-cnn-12-6/resolve/main/pytorch_model.bin -o ./sshleifer/distilbart-cnn-12-6/pytorch_model.bin
RUN curl -L https://huggingface.co/sshleifer/distilbart-cnn-12-6/resolve/main/rust_model.ot -o ./sshleifer/distilbart-cnn-12-6/rust_model.ot
RUN curl -L https://huggingface.co/sshleifer/distilbart-cnn-12-6/raw/main/tokenizer_config.json -o ./sshleifer/distilbart-cnn-12-6/tokenizer_config.json
RUN curl -L https://huggingface.co/sshleifer/distilbart-cnn-12-6/raw/main/vocab.json -o ./sshleifer/distilbart-cnn-12-6/vocab.json

#Run install
RUN pip install Brotli -q --target "${LAMBDA_TASK_ROOT}"
RUN pip install certifi -q --target "${LAMBDA_TASK_ROOT}"
RUN pip install chardet -q --target "${LAMBDA_TASK_ROOT}"
RUN pip install click -q --target "${LAMBDA_TASK_ROOT}"
RUN pip install filelock -q --target "${LAMBDA_TASK_ROOT}"
#RUN pip install Flask -q --target "${LAMBDA_TASK_ROOT}"
#RUN pip install Flask-Compress -q --target "${LAMBDA_TASK_ROOT}"
RUN pip install future -q --target "${LAMBDA_TASK_ROOT}"
#RUN pip install gunicorn -q --target "${LAMBDA_TASK_ROOT}"
RUN pip install idna -q --target "${LAMBDA_TASK_ROOT}"
RUN pip install itsdangerous -q --target "${LAMBDA_TASK_ROOT}"
RUN pip install Jinja2 -q --target "${LAMBDA_TASK_ROOT}"
RUN pip install joblib -q --target "${LAMBDA_TASK_ROOT}"
RUN pip install MarkupSafe -q --target "${LAMBDA_TASK_ROOT}"
RUN pip install numpy -q --target "${LAMBDA_TASK_ROOT}"
RUN pip install packaging -q --target "${LAMBDA_TASK_ROOT}"
RUN pip install pandas -q --target "${LAMBDA_TASK_ROOT}"
#RUN pip install Pillow -q --target "${LAMBDA_TASK_ROOT}"
RUN pip install pyparsing -q --target "${LAMBDA_TASK_ROOT}"
RUN pip install python-dateutil -q --target "${LAMBDA_TASK_ROOT}"
RUN pip install pytz -q --target "${LAMBDA_TASK_ROOT}"
RUN pip install regex -q --target "${LAMBDA_TASK_ROOT}"
RUN pip install requests -q --target "${LAMBDA_TASK_ROOT}"
RUN pip install retrying -q --target "${LAMBDA_TASK_ROOT}"
RUN pip install sacremoses -q --target "${LAMBDA_TASK_ROOT}"
RUN pip install six -q --target "${LAMBDA_TASK_ROOT}"
RUN pip install torch -q --target "${LAMBDA_TASK_ROOT}"
RUN pip install torchaudio -q --target "${LAMBDA_TASK_ROOT}"
RUN pip install torchvision -q --target "${LAMBDA_TASK_ROOT}"
RUN pip install tqdm -q --target "${LAMBDA_TASK_ROOT}"
RUN pip install transformers -q --target "${LAMBDA_TASK_ROOT}"
RUN pip install typing-extensions -q --target "${LAMBDA_TASK_ROOT}"
RUN pip install urllib3 -q --target "${LAMBDA_TASK_ROOT}"
RUN pip install Werkzeug -q --target "${LAMBDA_TASK_ROOT}"
#RUN pip install sentence_transformers -q --target "${LAMBDA_TASK_ROOT}"
RUN pip install boto3 -q --target "${LAMBDA_TASK_ROOT}"

# Set the CMD to your handler (could also be done as a parameter override outside of the Dockerfile)
CMD ["app.lambda_handler"]
