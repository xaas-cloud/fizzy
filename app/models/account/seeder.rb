class Account::Seeder
  attr_reader :account, :creator

  def initialize(account, creator)
    @account = account
    @creator = creator
  end

  def seed
    Current.set session: session do
      populate
    end
  end

  def seed!
    raise "You can't run in production environments" unless Rails.env.local?

    delete_everything
    seed
  end

  private
    def session
      creator.identity.sessions.last
    end

    def populate
      # ---------------
      # Playground Collection
      # ---------------
      playground = Collection.create! name: "Playground", creator: creator, all_access: true

      # Cards
      have_fun_card = playground.cards.create! creator: creator, title: "Have fun!", status: "published", description: <<~HTML
        <p>Mess around, make more boards, add more cards, and get your work, issues, or ideas organized! Include a video of the full product walkthrough.</p>
      HTML

      playground.cards.create! creator: creator, title: "Head back home to check out activity", status: "published", description: <<~HTML
        <p>Hit “1” or pull down the BOXCAR menu and select “Home”.</p>
      HTML

      playground.cards.create! creator: creator, title: "Check out all cards assigned to you", status: "published", description: <<~HTML
        <p>Pull down the Fizzy menu at the top of the screen, and select “Assigned to me” or just type “3” any time.</p>
      HTML

      playground.cards.create! creator: creator, title: "Grab the invite link to invite someone else", status: "published", description: <<~HTML
        <p>Pull down the Fizzy menu at the top of the screen, select “Account” or just hit 6, then grab the invite link over on the left side. You can give this link to someone else so they can make an login for themselves in your account.</p>
      HTML

      playground.cards.create! creator: creator, title: "Grab the invite link to invite someone else", status: "published", description: <<~HTML
        <p>Pull down the Fizzy menu at the top of the screen, select “Account” or just hit 6, then grab the invite link over on the left side. You can give this link to someone else so they can make an login for themselves in your account.</p>
      HTML

      playground.cards.create! creator: creator, title: "Assign this card to yourself", status: "published", description: <<~HTML
        <p>Click the little head with the + next to it, pick yourself.</p>
      HTML

      playground.cards.create! creator: creator, title: "Tag this card “Design” then move it to YES", status: "published", description: <<~HTML
        <p>Click the little Tag icon, type Design, then save. Then, move the card to the new “YES” column you created in the previous step.</p>
      HTML

      playground.cards.create! creator: creator, title: "Make two more columns", status: "published", description: <<~HTML
        <ol>
          <li>Make one called "Yes"</li>
          <li>Make another called "Working on"</li>
        </ol>
        <p><br></p>
        <p>Go back to the Board view, click the little “+” to the right of the DONE column, name the column, pick a color, then do it again.</p>
        <p><br></p>
        <p>After that, drag this card to “DONE” or select “DONE” in the sidebar.</p>
      HTML

      playground.cards.create! creator: creator, title: "Move this card to NOT NOW", status: "published", description: <<~HTML
        <p>You can either select “NOT NOW” over in the sidebar, or you can go back out to the Board view and drag this card into the NOT NOW column on the left side.</p>
      HTML

      playground.cards.create! creator: creator, title: "Rename this card", status: "published", description: <<~HTML
        <p>Click the title and you can rename the card, change the description, or add more information to the card.</p>
      HTML
    end

    def delete_everything
      Current.set session: session do
        Collection.destroy_all
      end
    end
end
