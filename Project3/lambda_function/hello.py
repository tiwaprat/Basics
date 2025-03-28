import json
import boto3
import os
from PIL import Image
from io import BytesIO

s3 = boto3.client('s3')

def lambda_handler(event, context):
    # Extract the S3 bucket name and file name (key) from the event
    bucket_a = os.getenv('SOURCE_BUCKET')  # Source bucket name from environment
    bucket_b = os.getenv('DEST_BUCKET')  # Destination bucket name from environment
    object_key = event['Records'][0]['s3']['object']['key']
    
    # Get the image from S3 bucket A
    print(f"Getting image from {bucket_a}/{object_key}")
    response = s3.get_object(Bucket=bucket_a, Key=object_key)
    
    # Read the image data from the response
    img_data = response['Body'].read()
    
    # Open the image with Pillow
    image = Image.open(BytesIO(img_data))
    
    # Resize the image (e.g., 800x800)
    new_size = (500, 500)  # You can adjust the size as needed
    resized_image = image.resize(new_size)
    
    # Save the resized image to a buffer
    img_byte_array = BytesIO()
    resized_image.save(img_byte_array, format='PNG')
    img_byte_array.seek(0)  # Rewind the buffer to the beginning
    
    # Upload the resized image to S3 bucket B
    destination_key = f"{object_key}"  # You can customize the key as needed
    print(f"Uploading resized image to {bucket_b}/{destination_key}")
    
    s3.put_object(
        Bucket=bucket_b,
        Key=destination_key,
        Body=img_byte_array,
        ContentType='image/png'  # Make sure to set the appropriate content type
    )
    
    return {
        'statusCode': 200,
        'body': json.dumps(f"Image resized and uploaded to {bucket_b}/{destination_key}")
    }
