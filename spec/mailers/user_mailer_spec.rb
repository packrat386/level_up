require "spec_helper"

describe UserMailer do
  let(:enrollment) { build(:enrollment) }
  let(:user) { enrollment.user }
  let(:course) { enrollment.course }
  let(:slack_invite_url) { "https://levelupslackinvites.herokuapp.com/" }

  describe "#confirm_enrollment" do
    let(:mail) { UserMailer.confirm_enrollment(user, course) }

    it "confirms course enrollment" do
      expect(mail.to).to include(user.email)
      expect(mail.body).to include(course.name)
    end

    it "actually sends the email" do
      expect { mail.deliver_now! }.to change { deliveries }.by(1)
    end

    it "includes some helpful links" do
      expect(mail.body).to include(slack_invite_url)
    end
  end

  describe "#slack_reminder" do
    let(:mail) { UserMailer.slack_reminder(user) }

    it "includes the slack invite link" do
      expect(mail.to).to include(user.email)
      expect(mail.body).to include(slack_invite_url)
    end

    it "actually sends the email" do
      expect { mail.deliver_now! }.to change { deliveries }.by(1)
    end
  end

  describe "#activity_reminder" do
    let(:mail) { UserMailer.activity_reminder(enrollment) }

    it "includes some helpful links" do
      expect(mail.body).to include(slack_invite_url)
    end

    it "actually sends the email" do
      expect { mail.deliver_now! }.to change { deliveries }.by(1)
    end
  end

  describe "#reg_reminder" do
    let(:mail) { UserMailer.reg_reminder(user) }

    it "includes some helpful links" do
      expect(mail.body).to include(slack_invite_url)
    end

    it "actually sends the email" do
      expect { mail.deliver_now! }.to change { deliveries }.by(1)
    end
  end

  def deliveries
    ActionMailer::Base.deliveries.size
  end
end
