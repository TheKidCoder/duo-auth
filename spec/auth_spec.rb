require 'spec_helper'

describe Duo::Auth do
  context 'signing request' do
    subject {Duo::Auth}
    it 'creates a proper response with valid arguments' do
      expect(subject.sign_request(IKEY, SKEY, AKEY, USER)).not_to be_nil
    end

    it 'expects a user ID' do
      expect(subject.sign_request(IKEY, SKEY, AKEY, '')).to be(Duo::ERR_USER)
    end

    it 'cannot have a pipe character in the user key' do
      expect(subject.sign_request(IKEY, SKEY, AKEY, 'in|valid')).to be(Duo::ERR_USER)
    end

    it 'expects a valid integration key' do
      expect(subject.sign_request('invalid', SKEY, AKEY, USER)).to be(Duo::ERR_IKEY)
    end

    it 'expects a valid secret key' do
      expect(subject.sign_request(IKEY, 'invalid', AKEY, USER)).to be(Duo::ERR_SKEY)
    end

    it 'expects a valid application key' do
      expect(subject.sign_request(IKEY, SKEY, 'invalid', USER)).to be(Duo::ERR_AKEY)
    end
  end

  context 'verifying a response' do
    let(:request_sig) {Duo::Auth.sign_request(IKEY, SKEY, AKEY, USER)}
    let(:valid_app_sig) {request_sig.to_s.split(':').last}

    let(:invalid_request_sig) {Duo::Auth.sign_request(IKEY, SKEY, 'invalid' * 6, USER)}
    let(:invalid_app_sig) {invalid_request_sig.to_s.split(':').last}

    it 'rejects an invalid user' do
      expect(Duo::Auth.verify_response(IKEY, SKEY, AKEY, INVALID_RESPONSE + ':' + valid_app_sig)).to be_nil
    end

    it 'rejects expired responses' do
      expect(Duo::Auth.verify_response(IKEY, SKEY, AKEY, EXPIRED_RESPONSE + ':' + valid_app_sig)).to be_nil
    end

    it 'rejects responses with invalid app sig' do
      expect(Duo::Auth.verify_response(IKEY, SKEY, AKEY, FUTURE_RESPONSE + ':' + invalid_app_sig)).to be_nil
    end

    it 'allows responses with valid app sig' do
      expect(Duo::Auth.verify_response(IKEY, SKEY, AKEY, FUTURE_RESPONSE + ':' + valid_app_sig)).to eq(USER)
    end

    it 'rejects wrong params' do
      expect(Duo::Auth.verify_response(IKEY, SKEY, AKEY, FUTURE_RESPONSE + ':' + WRONG_PARAMS_APP)).to be_nil
    end

    it 'rejects wrong params from response' do
      expect(Duo::Auth.verify_response(IKEY, SKEY, AKEY, WRONG_PARAMS_RESPONSE + ':' + valid_app_sig)).to be_nil
    end

    it 'will not verify with wrong integration key' do
      expect(Duo::Auth.verify_response(WRONG_IKEY, SKEY, AKEY, FUTURE_RESPONSE + ':' + valid_app_sig)).to be_nil
    end

  end
end