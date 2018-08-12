import urllib.request
import urllib.parse
import json
import Levenshtein
import boto3


def main(event, context):
    input = get_s3_event_json(event)
    template = get_s3_json('dokode', 'title/template/template.json')
    id_ranks = []
    for line in template:
        line['id'] != input['id'] and id_ranks.append({
            'distance': Levenshtein.distance(line['string'], input['string']),
            'string': line['string'],
            'id': line['id']})

    put_dynamo_table({'id': input['id'],
                      'string': input['string'],
                      'rank': json.dumps(sorted_array_dict(id_ranks, 'distance')[0:20], ensure_ascii=False)})


def put_dynamo_table(item):
    dynamodb_table = 'dokode_title'
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(dynamodb_table)
    table.put_item(Item=item)


def get_s3_json(bucket, key):
    response = boto3.client('s3').get_object(Bucket=bucket, Key=key)
    body = response['Body'].read()
    return json.loads(body.decode('utf-8'))


def get_s3_event_json(event):
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')
    body = boto3.client('s3').get_object(Bucket=bucket, Key=key)['Body'].read()
    return json.loads(body.decode('utf-8'))


def sorted_array_dict(array_dict, sort_key):
    return sorted(array_dict, key=lambda x: x[sort_key])
