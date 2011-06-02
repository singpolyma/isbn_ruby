#!/usr/bin/ruby
#
# Copyright (c) 2010, John D. Lewis <balinjdl at gmail.com>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
#
#    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
#    * Neither the name of the author nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

module ISBN
	module_function

	def verify(isbn_in, printValids=false)
		if isbn_in.length == 13
			return verify_isbn13(isbn_in.upcase, printValids)
		elsif isbn_in.length == 10
			return verify_isbn10(isbn_in.upcase, printValids)
		else
			return nil
		end
	end

	def verify_isbn10(isbn_in, printValids=false)
		retVal = false
		if (isbn_in.length == 10)
			chkDgtX = calc_checkDigit10(isbn_in[0,isbn_in.length-1])
			#puts "chkDgtX = #{chkDgtX}; isbn_in = #{isbn_in}; isbn(substr) = #{isbn_in[0,isbn_in.length-1]}"
			if isbn_in == isbn_in[0,isbn_in.length-1].to_s + chkDgtX.to_s.upcase
				retVal=true
				if printValids
					puts "valid check digit found in isbn #{isbn_in}!"
				end
			else
				puts "INVALID check digit in isbn #{isbn_in}!"
			end
		else
			puts "invalid isbn_in length (#{isbn_in.length})"
		end
		retVal
	end

	def verify_isbn13(isbn_in, printValids=false)
		retVal = false
		if (isbn_in.length == 13)
			chkDgt = calc_checkDigit13(isbn_in[0,isbn_in.length-1])
			#puts "chkDgt = #{chkDgt}; isbn_in = #{isbn_in}; isbn(substr) = #{isbn_in[0,isbn_in.length-1]}"
			if isbn_in == isbn_in[0,isbn_in.length-1].to_s + chkDgt.to_s
				retVal=true
				if printValids
					puts "valid check digit found in isbn #{isbn_in}!"
				end
			else
				puts "INVALID check digit in isbn #{isbn_in}!"
			end
		else
			puts "invalid isbn_in length (#{isbn_in.length})"
		end
		retVal
	end

	def calc_checkDigit(isbn_in)
		if isbn_in.length == 12
			return calc_checkDigit13(isbn_in)
		elsif isbn_in.length == 9
			return calc_checkDigit10(isbn_in)
		else
			return nil
		end
	end

	def calc_checkDigit10(isbn_in)
		charPos = 0
		csumTotal = 0
		iarr = isbn_in.split(//)
		for i2 in iarr
			charPos += 1
			csumTotal = csumTotal + (charPos * i2.to_i)
			#puts "csumTotal (running) = #{csumTotal}"
		end
		#puts "csumTotal = #{csumTotal}"
		checkDigit = csumTotal % 11
		if (checkDigit == 10)
			checkDigit = "X"
		end
		#puts "for partial isbn #{isbn_in} the checkDigit = #{checkDigit}; complete isbn = #{isbn_in}#{checkDigit}"
		checkDigit
	end

	def calc_checkDigit13(isbn_in)
		charPos = 0
		csumTotal = 0
		iarr = isbn_in.split(//)
		for i1 in iarr
			cP2 = charPos/2.to_f
			#puts "#{cP2}; #{cP2.round}; #{cP2.floor}"

			if (cP2.round == cP2.floor)
				csumTotal = csumTotal + i1.to_i
				#puts "csumTotal_a = #{csumTotal} + #{i1.to_i}"
			else
				csumTotal = csumTotal + (3*i1.to_i)
				#puts "csumTotal_b = #{csumTotal} + #{3*i1.to_i}"
			end
			charPos += 1
		end
			#puts "csumTotal = #{csumTotal}"
			if (csumTotal == (csumTotal/10.to_i)*10)
				checkDigit = "0"
			else
				checkDigit = 10-(csumTotal - (csumTotal/10.to_i)*10)
			end

			#puts "checkDigit = 10-(#{csumTotal} - #{(csumTotal/10.to_i)*10})"
			if (checkDigit == 10)
				checkDigit = "X"
			end
			#puts "for partial isbn #{isbn_in} the checkDigit = #{checkDigit}; complete isbn = #{isbn_in}#{checkDigit}"
			checkDigit
	end

	def fix(isbn)
		return isbn[0,isbn.length-1] + calc_checkDigit(isbn).to_s
	end

end
