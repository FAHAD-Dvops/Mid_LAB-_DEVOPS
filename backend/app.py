#!/usr/bin/env python3
"""
DevOps Web Application Backend
Flask API for the DevOps pipeline demo
"""

from flask import Flask, render_template, request, jsonify
from flask_cors import CORS
import os
from datetime import datetime
import logging

# Initialize Flask app
app = Flask(__name__, static_folder='.', static_url_path='', template_folder='.')

# Enable CORS
CORS(app)

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Application version
VERSION = "1.0.0"
ENVIRONMENT = os.getenv('ENVIRONMENT', 'development')


@app.route('/')
def index():
    """Serve the main index.html page"""
    return app.send_static_file('index.html')


@app.route('/api/status', methods=['GET'])
def status():
    """Get backend status"""
    return jsonify({
        'status': 'online',
        'version': VERSION,
        'environment': ENVIRONMENT,
        'timestamp': datetime.now().isoformat()
    }), 200


@app.route('/api/submit', methods=['POST'])
def submit():
    """Handle form submission"""
    try:
        data = request.get_json()
        
        # Validate required fields
        if not data or not all(key in data for key in ['name', 'email', 'message']):
            return jsonify({
                'success': False,
                'message': 'Missing required fields: name, email, message'
            }), 400
        
        # Log the submission
        logger.info(f"Form submission from {data['email']}: {data['name']}")
        
        # Process the data
        name = data['name'].strip()
        email = data['email'].strip()
        message = data['message'].strip()
        
        # Validate input lengths
        if len(name) < 2 or len(name) > 100:
            return jsonify({
                'success': False,
                'message': 'Name must be between 2 and 100 characters'
            }), 400
        
        if len(email) < 5 or len(email) > 100:
            return jsonify({
                'success': False,
                'message': 'Email must be between 5 and 100 characters'
            }), 400
        
        if len(message) < 10 or len(message) > 1000:
            return jsonify({
                'success': False,
                'message': 'Message must be between 10 and 1000 characters'
            }), 400
        
        # Simulate processing
        response_data = {
            'success': True,
            'message': f'Thank you {name}! Your message has been received. We will contact you at {email} soon.',
            'data': {
                'name': name,
                'email': email,
                'submitted_at': datetime.now().isoformat()
            }
        }
        
        return jsonify(response_data), 201
    
    except Exception as e:
        logger.error(f"Error processing request: {str(e)}")
        return jsonify({
            'success': False,
            'message': 'An error occurred while processing your request'
        }), 500


@app.route('/api/health', methods=['GET'])
def health():
    """Health check endpoint for monitoring"""
    return jsonify({
        'status': 'healthy',
        'version': VERSION,
        'timestamp': datetime.now().isoformat()
    }), 200


@app.route('/api/info', methods=['GET'])
def info():
    """Get application information"""
    return jsonify({
        'name': 'DevOps Web Application',
        'version': VERSION,
        'environment': ENVIRONMENT,
        'description': 'Laravel/PHP web application with CI/CD pipeline',
        'timestamp': datetime.now().isoformat()
    }), 200


@app.errorhandler(404)
def not_found(error):
    """Handle 404 errors"""
    return jsonify({
        'error': 'Not Found',
        'message': 'The requested resource was not found'
    }), 404


@app.errorhandler(500)
def internal_error(error):
    """Handle 500 errors"""
    logger.error(f"Internal server error: {str(error)}")
    return jsonify({
        'error': 'Internal Server Error',
        'message': 'An internal server error occurred'
    }), 500


if __name__ == '__main__':
    port = int(os.getenv('PORT', 5000))
    debug = ENVIRONMENT == 'development'
    
    logger.info(f"Starting application on port {port} in {ENVIRONMENT} mode")
    app.run(host='0.0.0.0', port=port, debug=debug)
