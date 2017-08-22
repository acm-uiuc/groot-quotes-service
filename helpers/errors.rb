# Copyright © 2017, ACM@UIUC
#
# This file is part of the Groot Project.
#
# The Groot Project is open source software, released under the University of
# Illinois/NCSA Open Source License. You should have received a copy of
# this license in a file with the distribution.

require_relative 'response_format'
module Errors
  VERIFY_CORPORATE_SESSION = ResponseFormat.error 'Corporate session could not be verified'
  VERIFY_GROOT = ResponseFormat.error 'Request did not originate from groot'

  DUPLICATE_QUOTE = ResponseFormat.error 'Quote already exists'
  DUPLICATE_VOTE = ResponseFormat.error 'Vote already cast'
  QUOTE_NOT_FOUND = ResponseFormat.error 'Quote not found'
  VOTE_NOT_FOUND = ResponseFormat.error 'Vote not found'

  QUOTE_APPROVED = ResponseFormat.error 'Quote already approved'
end
