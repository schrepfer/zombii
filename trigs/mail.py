#!/usr/bin/env python
#
# Copyright 2010. All Rights Reserved.

"""Send e-mail."""

__author__ = 'schrepfer'

import ConfigParser
import email
import os
import re
import smtplib

FORMAT = {
    'account': ['fullname', 'username'],
    'smtp': ['server', 'port', 'usettls'],
    }

def ReadConfig(config_file='mail.cfg'):
  assert os.path.isfile(config_file), 'Missing file: %s' % config_file

  config = ConfigParser.ConfigParser()
  config.read(config_file)

  for section, options in FORMAT.iteritems():
    assert config.has_section(section), 'Missing section: %s' % section
    for option in options:
      assert config.has_option(section, option), 'Missing option: %s > %s' % (section, option)

  return config


def Send(recipients, subject, text):
  """Log in to an SMTP server and send mail.

  Args:
    recipients: String; List of recipients to send to.
    subject: String; The subject of the email.
    text: String; The body of the email.

  Returns:
    True on success. False otherwise.
  """
  config = ReadConfig()

  body = email.mime.Multipart.MIMEMultipart()
  body['From'] = '%s <%s>' % (
      config.get('account', 'fullname'),
      config.get('account', 'username'))
  body['To'] = recipients
  body['Subject'] = subject
  body.attach(email.mime.Text.MIMEText(text))

  try:
    smtp = smtplib.SMTP(
        config.get('smtp', 'server'),
        int(config.get('smtp', 'port')))
    if config.has_option('account', 'password'):
      if int(config.get('smtp', 'usettls')):
        smtp.ehlo()
        smtp.starttls()
      smtp.ehlo()
      smtp.login(
          config.get('account', 'username'),
          config.get('account', 'password'))
    smtp.sendmail(
        config.get('account', 'username'),
        re.split('[;, ]+', recipients),
        body.as_string())
    smtp.quit()
  except smtplib.SMTPException:
    return False

  return True
