# Project 3 - TwitterClient

TwitterClient is a basic twitter app to read and compose tweets the [Twitter API](https://apps.twitter.com).

Time spent: 40 hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign in using OAuth login flow.
- [x] User can view last 20 tweets from their home timeline.
- [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.  In other words, design the custom cell with the proper Auto Layout settings.  You will also need to augment the model classes.
- [x] User can pull to refresh.
- [x] User can compose a new tweet by tapping on a compose button.
- [x] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
- [x] Tab Bar
   - [x] Use a `UITabBarController`
   - [x] The tab bar should include links to your profile, the home timeline, and the mentions view.
- [x] Profile page
   - [x] Contains the user header view (implemented as a custom view)
   - [x] Contains a section with the users basic stats: # tweets, # following, # followers
- [x] Home Timeline
   - [x] Tapping on a user image should bring up that user's profile page

The following **optional** features are implemented:

- [x] When composing, you should have a countdown in the upper right for the tweet limit.
- [x] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [x] Retweeting and favoriting should increment the retweet and favorite count.
- [ ] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [x] Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
- [x] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.
- [ ] Pulling down the profile page should blur and resize the header image.
- [ ] Account switching
   - [ ] Long press on tab bar to bring up Account view with animation
   - [ ] Tap account to switch to
   - [ ] Include a plus button to Add an Account
   - [ ] Swipe to delete an account

The following **additional** features are implemented:

- [x] Introducted new TableViewCellDelegate for handling tap on profile image in a tweet
- [x] Created a new delegate for UIViewController to pass interaction events
- [x] Implemented a Menu View Controller, which conforms to the above protocol. This menu has the option to signout.
- [x] Added a pan gesture on table view, that only works when user swipes to right, to show the Menu View. Added animation to show and hide the Menu View on pan.
- [x] Created a hamburger menu bar button item that intorduces another way to pull the Menu View from the left side.
- [x] Retweeting and Favoriting a tweet changes the color of the icons to indicate the operation was done successfully.
- [x] Implemented the User Profile View to show list of tweets for the user and also the faviroted tweets in a table view below the custom haeder view.
- [x] Created the Tweet Detail View as a ScrollView, so that when the user taps on Reply, the view scrolls to a View (initially hidden) that shows the reply text field with the username prepopulated. Also added a reply button next to the text field, to make it easier to perform the action.
- [x] Added custom look for the Navigation and Tab Bar Controllers.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/rpQ6VSk.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

## License

    Copyright [2017] [Abhishek Prabhudesai]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
