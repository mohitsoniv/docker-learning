import sys
import logging
from pythonjsonlogger import jsonlogger

# Configure logger to output JSON-formatted logs to stderr
logger = logging.getLogger()
log_handler = logging.StreamHandler(stream=sys.stderr)
formatter = jsonlogger.JsonFormatter()
log_handler.setFormatter(formatter)
logger.addHandler(log_handler)

# Log some messages
logger.info("This is an info message", extra={"user_id": 123})
logger.warning("This is a warning message", extra={"user_id": 456})
logger.error("This is an error message", extra={"user_id": 789})