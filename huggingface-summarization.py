from transformers import pipeline
import pandas as pd
import json
import boto3
import botocore
from base64 import b64encode

#load pipeline
nlp = pipeline("summarization")

#load clients
s3Client = boto3.client('s3')

#Results
sResult = ""

def lambda_handler(event, context):
    sContext = event.get("Context")
    iMin = event.get("Min")
    iMax = event.get("Max")
    if (sContext == ""):
      sBucket = event.get("Bucket")
      sKey = event.get("Key")
      sContext = getContent(sBucket, sKey)
    
    #Get Results
    if sContext != "": #Ensure values are populated
        sResult = genSummary(sContext, iMin, iMax)
        print(sResult)
        
    #event_dict = json.loads(event) #if "key" in "dict"
    #sSrcBucket = event["detail"]["ProcessOutputBucket"]
    #sSrcKey = event["detail"]["ProcessOutputKey"]
    #sSrcExtension = event["detail"]["ProcessExtension"]
    #sAssetId = event["detail"]["AssetId"]
    
    return {
        'statusCode': 200,
        'body': sResult #return answers to caller
    }

#grab s3 object with text content
def getContent(srcBucket, srcKey):
    objContent = s3Client.get_object(Bucket=srcBucket, Key=srcKey)
    response = objContent['Body'].read()
    return response
  
#Generate the answers to the question.
def genSummary(text, iMin, iMax):
    summary = summarizer(text, iMax, iMin)
    print(summary[0].get('summary_text'))
    return summary[0].get('summary_text')
#    for i in range(min(len(df), topn)):
#      df.iloc[i]["answer"]
#      #columns: answer, score, start, end
