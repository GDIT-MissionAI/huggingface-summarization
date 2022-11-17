import os
os.environ['TRANSFORMERS_CACHE'] = '/tmp'
from transformers import pipeline, AutoModel
#import pandas as pd
import json
import boto3
import botocore
from base64 import b64encode

#load pipeline
#summarizer = pipeline("summarization")
#summarizer = pipeline(model = "sshleifer/distilbart-cnn-12-6", tokenizer ="sshleifer/distilbart-cnn-12-6")


summarizer = pipeline(task = "summarization", model = "./models/distilbart-cnn-12-6", tokenizer ="./models/distilbart-cnn-12-6")


#load clients
s3Client = boto3.client('s3')

#Results
sResult = ""

def lambda_handler(event, context):
    print(event)
    sContext = event.get("Context")
    if (sContext == ""):
      sBucket = event.get("Bucket")
      sKey = event.get("Key")
      sContext = getContent(sBucket, sKey)
    
    #Get Results
    if sContext != "": #Ensure values are populated
        sResult = genSummary(sContext)
        print(sResult)
        
    #event_dict = json.loads(event) #if "key" in "dict"
    #sSrcBucket = event["detail"]["ProcessOutputBucket"]
    #sSrcKey = event["detail"]["ProcessOutputKey"]
    #sSrcExtension = event["detail"]["ProcessExtension"]
    #sAssetId = event["detail"]["AssetId"]
    
    return {
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Origin': '*'
        },
        'body': sResult #return answers to caller
    }

#grab s3 object with text content
def getContent(srcBucket, srcKey):
    objContent = s3Client.get_object(Bucket=srcBucket, Key=srcKey)
    response = objContent['Body'].read()
    return response
  
#Generate the answers to the question.
def genSummary(text):
    #summary = summarizer(text, iMin, iMax)
    summary = summarizer(text)
    print(summary[0].get('summary_text'))
    return summary[0].get('summary_text')
#    for i in range(min(len(df), topn)):
#      df.iloc[i]["answer"]
#      #columns: answer, score, start, end
