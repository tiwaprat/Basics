FROM python:3.12

# Set the working directory
WORKDIR /usr/local/app

# Copy the app.py file into the container
COPY app.py ./

# Copy the requirements.txt file into the container (optional step, see explanation below)
COPY requirements.txt ./

# Install dependencies using pip
RUN pip install -r requirements.txt

# Create the templates directory if it doesn't exist
RUN mkdir -p templates

# Copy the index.html into the templates directory
COPY index.html ./templates/

# Expose port 80 for the application
EXPOSE 80

# Set the command to run the app with binding to 0.0.0.0
CMD ["python", "app.py"]

