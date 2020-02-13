## Contributing ##

You can contribute to this repo if you have an issue, found a bug or think there's some functionality required that would add value to the gem. To do so, please check if there's not already an [issue](https://github.com/rootstrap/gem-base/issues) for that, if you find there's not, create a new one with as much detail as possible.

If you want to contribute with code as well, please follow the next steps:

1. Read, understand and agree to our [code of conduct](https://github.com/rootstrap/gem-base/blob/master/CODE_OF_CONDUCT.md)
2. [Fork the repo](https://help.github.com/articles/about-forks/)
3. Clone the project into your machine:
`$ git clone git@github.com:[YOUR GITHUB USERNAME]/gem-base.git`
4. Access the repo:
`$ cd gem-base`
5. Create your feature/bugfix branch:
`$ git checkout -b your_new_feature`
or
`$ git checkout -b fix/your_fix` in case of a bug fix
(if your PR is to address an existing issue, it would be good to name the branch after the issue, for example: if you are trying to solve issue 182, then a good idea for the branch name would be `182_your_new_feature`)
6. Write tests for your changes (feature/bug)
7. Code your (feature/bugfix)
8. Run the code analysis tool by doing:
`$ rake code_analysis`
9. Run the tests:
`$ bundle exec rspec`
All tests must pass. If all tests (both code analysis and rspec) do pass, then you are ready to go to the next step:
10. Commit your changes:
`$ git commit -m 'Your feature or bugfix title'`
11. Push to the branch `$ git push origin your_new_feature`
12. Create a new [pull request](https://help.github.com/articles/creating-a-pull-request/)

Some helpful guides that will help you know how we work:
1. [Code review](https://github.com/rootstrap/tech-guides/tree/master/code-review)
2. [GIT workflow](https://github.com/rootstrap/tech-guides/tree/master/git)
3. [Ruby style guide](https://github.com/rootstrap/tech-guides/tree/master/ruby)
4. [Rails style guide](https://github.com/rootstrap/tech-guides/blob/master/ruby/rails.md)
5. [RSpec style guide](https://github.com/rootstrap/tech-guides/blob/master/ruby/rspec/README.md)

For more information or guides like the ones mentioned above, please check our [tech guides](https://github.com/rootstrap/tech-guides). Keep in mind that the more you know about these guides, the easier it will be for your code to get approved and merged.

Note: We work with one commit per pull request, so if you make your commit and realize you were missing something or want to add something more to it, don't create a new commit with the changes, but use `$ git commit --amend` instead. This same principle also applies for when changes are requested on an open pull request.


Thank you very much for your time and for considering helping in this project.
