RSpec.describe AppData, type: :model do
  subject { described_class }

  after do
    File.open(Rails.root.join('lib', AppData::DATA_FILE), 'w') { |f| f.write data.to_yaml }
  end

  let(:data) do
    { app_data: {
      string_value: 'Just a string',
      array_of_objects: [{ id: 1, name: 'One' }, { id: 2, name: 'Two' }],
      object: { key: 'value', another_key: 'another value' }
    } }
  end

  before do
    stub_const("AppData::DATA_FILE", 'test_data.yml')
    allow(subject).to receive(:data).and_return(data)
  end

  it { is_expected.to respond_to(:data) }
  it { is_expected.to respond_to(:sections) }
  it { is_expected.to respond_to(:update) }

  describe 'based on app_data object' do
    it { expect(subject.string_value).to be_truthy }
    it { expect(subject.array_of_objects).to be_truthy }
    it { expect(subject.object).to be_truthy }
    it { expect { subject.anything_that_is_not_present_as_key }.to raise_error NoMethodError }
  end

  describe '#data' do
    it { expect(subject.data).to eq data }
  end

  describe '#sections' do
    it { expect(subject.sections).to include(:string_value, :array_of_objects, :object) }
  end

  describe '#update' do
    describe 'a .string_value after successful update' do
      before do
        described_class.update(:string_value, 'A new string')
      end

      it { expect(subject.string_value).to eq 'A new string' }
    end

    describe 'a .array_of_objects after successful update' do
      let(:expected_outcome) { [{ id: 1, name: 'One' }, { id: 2, name: 'Two' }, { id: 3, name: 'Three' }] }
      before do
        described_class.update(:array_of_objects, [{ id: 3, name: 'Three' }])
      end

      it { expect(subject.array_of_objects).to eq expected_outcome }
    end
  end
end
