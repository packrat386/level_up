require 'spec_helper'

describe EnrollUser do
  let(:course) { create(:course) }
  let(:user) { create(:user) }
  let(:interactor) { EnrollUser.call(course: course, user: user) }

  context "when the interactor is a success" do
    let(:mail) { double("AdminMailer", deliver_now: true) }

    it "allows a user to register for a course" do
      expect(interactor).to be_success
      expect(user.courses).to include(course)
    end

    # TODO: this really should be dependency injected
    # at which point the .and_return should move to
    # a double(confirm_enrollment: mail)
    it "sends welcome and notification emails" do
      expect(AdminMailer).to receive(:confirm_enrollment).once
        .with(user, course).and_return(mail)
      expect(UserMailer).to receive(:confirm_enrollment).once
        .with(user, course).and_return(mail)

      expect(interactor).to be_success
    end
  end

  context "when emails cannot be sent" do
    let(:mail) { double("AdminMailer", deliver_now: false) }

    it "fails when emails cannot be sent properly" do
      expect(AdminMailer).to receive(:confirm_enrollment)
        .with(user, course).and_return(mail)

      expect(interactor).not_to be_success
    end
  end
end
