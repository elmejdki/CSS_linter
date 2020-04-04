require_relative '../lib/parser'

RSpec.describe Parser do
  let(:valid_parser) { Parser.new('tests/valid.css') }
  let(:invalid_parser) { Parser.new('tests/invalid.css') }

  context 'running the linter' do
    it 'return true empty array if the css is valid' do
      valid_parser.lunch_linter
      expect(valid_parser.error_output).to eql([])
    end

    it 'return true empty array if the css is invalid' do
      invalid_parser.lunch_linter
      expect(invalid_parser.error_output).not_to eql([])
    end
  end
  # rubocop:disable Metrics/BlockLength
  context 'running selector methods' do
    it 'return true if it takes a string that resemble to a css selector' do
      expect(valid_parser.selector?('.nav #trumbetron >  .name: hover{  ')).to eql true
    end

    it 'return false if it takes a string that doesn\'t resemble to a css selector' do
      expect(valid_parser.selector?('nav>?;: {')).to eql false
    end

    it 'return true if a selector has a whitespace at the end' do
      expect(valid_parser.whitespace_end_line?('header .nav {  ')).to eql true
    end

    it 'return false if a selector has no whitespace at the end' do
      expect(valid_parser.whitespace_end_line?('header .nav {')).to eql false
    end

    it 'return true if a selector has space after the {' do
      expect(valid_parser.whitespace_after_brac?('header .nav {  ')).to eql true
    end

    it 'return false if a selector has no space after {' do
      expect(valid_parser.whitespace_after_brac?('header .nav {')).to eql false
    end

    it 'return true if there is extras whitespace before brackets' do
      expect(valid_parser.extras_whitespace_before_brac?('header .nav    {')).to eql true
    end

    it 'return false if there is no extras whitespace before brackets' do
      expect(valid_parser.extras_whitespace_before_brac?('header .nav {')).to eql false
    end

    it 'return true if there is a missing space before {' do
      expect(valid_parser.missing_space_before_brac?('header .nav{')).to eql true
    end

    it 'return false if there is no missing space before {' do
      expect(valid_parser.missing_space_before_brac?('header .nav {')).to eql false
    end

    it 'return true if there is space after colon in pseudo-class' do
      expect(valid_parser.whitespace_colon?('header .nav: hover {')).to eql true
    end

    it 'return true if there is no space after colon in pseudo-class' do
      expect(valid_parser.whitespace_colon?('header .nav:hover {')).to eql false
    end

    it 'return true if there is extras space before selector' do
      expect(valid_parser.extras_space_before_selector?('   header .nav: hover {')).to eql true
    end

    it 'return true if there is no extras space before selector' do
      expect(valid_parser.extras_space_before_selector?('header .nav:hover {')).to eql false
    end
  end
  # rubocop:enable Metrics/BlockLength

  context 'running declaration methods' do
    it 'return true if there is a missing space after colon' do
      expect(valid_parser.missing_space_after_colon?('width:23px;')).to eql true
    end

    it 'return false if there is a missing space after colon' do
      expect(valid_parser.missing_space_after_colon?('width: 23px;')).to eql false
    end

    it 'return true if there is extras whitespace after colon' do
      expect(valid_parser.whitespace_after_colon?('width:   23px;')).to eql true
    end

    it 'return false if there is no extras whitespace after colon' do
      expect(valid_parser.whitespace_after_colon?('width: 23px;')).to eql false
    end

    it 'return true if there is missing semi-colon' do
      expect(valid_parser.missing_semi_colon?('width: 23px')).to eql true
    end

    it 'return false if there is missing semi-colon' do
      expect(valid_parser.missing_semi_colon?('width: 23px;')).to eql false
    end

    it 'return true if there is whitespace after semi-colon' do
      expect(valid_parser.whitespace_declaration_end_line?('width: 25px;  ')).to eql true
    end

    it 'return false if there is no whitespace after semi-colon' do
      expect(valid_parser.whitespace_declaration_end_line?('width: 25px;')).to eql false
    end
  end

  context 'running selector end' do
    it 'return true if there is whitespace after }' do
      expect(valid_parser.whitespace_after_end_brac?('}   ')).to eql true
    end

    it 'return true if there is no whitespace after }' do
      expect(valid_parser.whitespace_after_end_brac?('}')).to eql false
    end

    it 'return true if there is whitespace before }' do
      expect(valid_parser.whitespace_before_end_brac?('   }')).to eql true
    end

    it 'return true if there is no whitespace before }' do
      expect(valid_parser.whitespace_before_end_brac?('}')).to eql false
    end
  end
end
