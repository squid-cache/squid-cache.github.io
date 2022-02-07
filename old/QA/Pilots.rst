#acl SquidWikiAdminGroup:read,write,admin All:read

= QA Pilots =

The Squid Project needs to reduce the number of regression bugs in Squid releases and development snapshots. The large number of regressions illustrate that our peer code reviews are naturally insufficient, and our post-commit build tests are woefully inadequate.

To partially address these systemic problems, the Squid Software Foundation plans to adjust the commit process (making successful regression testing mandatory before any commit) and to hire a paid DevOps/QA engineer to back that new process with the necessary infrastructure support. We already have a set of proxy testing tools, but the existing Project volunteers do not have enough time, interest, and/or skills to use/improve those tools and support the QA infrastructure. A paid engineer would be able to focus on that.

Before a regular QA Engineer position is filled, we offer the following pilot projects. These pilots will help the Project to select the most suitable candidate. They also provide a good illustration of the kind of challenges a Project QA Engineer will face.

Application --(is)--was open to anybody interested in doing the pilots and continuing working with the Squid Project afterwards. The Project ads were viewed by thousands of people. We received about 50 resumes and 10 completed applications. We selected one engineer to do the first Pilot (at least). It is our intention to complete all these pilot projects and then fill the QA Engineer position.

Please see the [[#Q_and_A|Q&A]] section for more info.

<<TableOfContents>>

== Application ==

/!\ Applications are now closed. You may submit yours as a backup in case the first Pilot projects fail, but please note that your application will receive very little attention until that failure (and we hope the pilots will succeed!).

||Due date:||2017-02-15 noon UTC (extended to 2017-02-17 noon UTC)||
||Preconditions:||desire and skills to complete the pilots and to continue working with the Project after that||

Please review the descriptions of all three pilots and the [[#Q_and_A|Q&A]] section before applying.

To apply, on your free-form application:

 1. list any relevant skills and accomplishments,
 1. propose the overall architecture for Pilot-1 and justify your design,
 1. specify your country of residence (where the pilot payments would need to be sent) and the preferred payment method,
 1. supply any other information you deem necessary.

Please email your complete application to <<MailTo(info@squid-cache.org)>> with ''QA pilots application'' as the exact email subject.

Applications received after the due date may be ignored. We hope to offer Pilot-1 to one of the applicants within three weeks after the due date.


== Pilot-1 ==

||Goal:||Protect Squid trunk from build failures||
||Duration:||4 weeks||
||Cost:||$1'000||
||Preconditions:||Project invitation based on the [[#Application|Application]]||

Currently, all accepted Squid code changes are first committed to Squid bzr repository. Jenkins notices a new commit and performs several build tests. If a build test fails, an email is sent to the squid-dev mailing list with the failure details. Humans usually notice the email report and fix the problem, but that may take a few days or even weeks. Meanwhile, the broken commit remains in Squid trunk, often blocking other work or tempting folks to commit untested code.

We would like to rearrange this scheme so that all accepted Squid code changes are queued ''before'' they are committed, and the build tests are performed against the queued rather than committed changes. If a change passes the build test, it is automatically committed. If a change fails the build test, it is removed from the queue. A change removal may have a cascading effect on other queued changes, of course, but that ought to be rare and is acceptable.

You may propose to migrate Squid from bzr to git and/or from Jenkins to another CI system. However, since any migration is a pain, you would need to convince the Project that the migration is worth it ''and'' provide the Project with enough information to make an informed decision (without forcing decision makers to study the alternatives themselves). Your proposal may require Pilot-1 duration and cost adjustments. However, proposals requiring significant cost increases are unlikely to be accepted.

Some build tests may use unreliable machines or experimental configurations. There should be a way to exclude them from disqualifying pending changes. They should still run and report failures but those failures should have no effect on automated commits.

It should still be possible to commit changes without going though the build validation process, but that functionality will be used in emergencies or similar extraordinary situations only. Even seemingly trivial changes are expected to go through the validation process.

Normally, accepted changes will be queued in FIFO order. However, it would be nice if core developers could reorder queued changes when necessary. That functionality is ''not'' required for Pilot-1 though.

Supporting a similar system for multiple Squid branches (trunk, v4.0, v3.5, etc.) is a plus but not a hard requirement for Pilot-1 which focuses on trunk.

Eventually, the same validate-before-commit principle will apply to other admission and testing activities, including:

 1. developer voting during review of the proposed changes (to officially accept the proposed change)
 1. code formatting changes (or perhaps that would be done automatically to queued changes?)
 1. compliance tests (using Co-Advisor test cases)
 1. performance tests (using Web Polygraph workloads)
 1. code quality tests (using Coverity test cases)
 1. black-box functionality tests (using Daft test cases)

Keeping these plans in mind is important for Pilot-1 (to avoid proposing an architecture that cannot accommodate those plans well), but implementing the corresponding features is ''outside'' Pilot-1 scope.

== Pilot-2 ==

||Goal:||Protect Squid trunk from HTTP compliance regressions||
||Duration:||4 weeks||
||Cost:||$800||
||Preconditions:||Successful Pilot-1 completion and Project invitation||

Currently, there is no automated, regular Squid testing for protocol compliance regressions or violations. Occasionally, developers run Co-Advisor tests and fix regression bugs. At some point, automated Co-Advisor testing was setup but it was poorly integrated and got neglected/abandoned.

This Pilot project enables automated Co-Advisor tests for pending Squid changes. Any worsening of a stable test case outcome (e.g., from "success" to "violation" or "failure") would disqualify the queued code change with a corresponding report emailed to squid-dev (and logged). An improvement of stable test case outcomes (e.g., from "violation" to "success") without any regressions in other test cases should automatically update the "golden result" that is used for regressions detection so that future changes have a higher bar to pass; a notification about the update should be emailed to squid-dev (and logged).

Co-Advisor comes with scripts to repeat tests and compare test results. Integrating those scripts with the CI infrastructure to satisfy the above requirements is the focus of Pilot-2. Cooperation with Measurement Factory engineers may be required for smooth integration. Learning how to configure and run Co-Advisor tests will be required, but it is not difficult and Measurement Factory can help with that.

It should be possible for core developers to ignore a given Co-Advisor test result so that the automated commit may proceed. This functionality would be useful if manual checks confirm that the alleged compliance regression was not Squid fault (or is actually desirable for some other reason).


== Pilot-3 ==

||Goal:||Protect Squid trunk from performance regressions||
||Duration:||6 weeks||
||Cost:||$1'200||
||Preconditions:||Successful Pilot-2 completion and Project invitation||

Currently, there is no automated, regular Squid testing for performance regressions which may go unnoticed for years. At some point, automated Web Polygraph testing was setup but it was not comprehensive enough and got neglected/abandoned. This Pilot project enables automated Polygraph tests for pending Squid changes. A performance regression detected by one of the tests would disqualify the queued code change with a corresponding report emailed to squid-dev (and logged). A significant performance improvement (without any regressions) should automatically update the "golden result" that is used for regressions detection so that future changes have a higher bar to pass; a notification about the update should be emailed to squid-dev (and logged).

Measurement Factory will provide the initial set of 3-5 Polygraph workloads for these tests. You will be responsible for scripting test execution and result analysis, although some existing scripts can be reused. You will need to find a way to execute performance-sensitive tests in a CI environment to minimize false alarms. Learning how to configure and run Web Polygraph tests will be required.


== Q and A ==

 1. What if I have questions not answered here?

   You may post your questions to <<MailTo(info@squid-cache.org)>>. However, most of the information required to successfully apply, plan, and complete Pilot-1 is publicly available. We hate discouraging questions (and some cooperation/discussion with the Project ''will'' be required during all pilots), but please keep in mind that nobody has the time for detailed answers, especially answers to unnecessary questions. Do your best to solve the problems on your own and, if you have to ask something, make it easy for others to answer your questions. During the application stage, we may update this page with more answers to popular questions.

 1. Can you detail the expected QA Engineer position?

   Just like the pilots, the QA Engineer position is for a part-time "remote" independent contractor. The engineer responsibilities will include:

      * Perform needs analysis and advise the Squid Project on available infrastructure tools and approaches for automating the regression testing process. Suggest specific alternatives and drive public discussions to arrive at the best solution for the Project. The candidate solutions may range from home-grown Jenkins scripts to commercial CI platforms (available to open source projects).
      * Automate and manage Squid regression testing. Integrate the existing proxy performance and functionality testing tools (including test-builds.sh, Coverity, Co-Advisor, Web Polygraph, and Daft) with the Project-designed infrastructure.
      * Learning HTTP and other Squid-related protocols with the goal of being eventually able to audit automated test results without deferring to Squid developers.
      * Long-term: Learning existing testing tools with the goal of being eventually able to create new test cases and fix old ones without deferring to tools developers.

   QA Engineer position prerequisites/requirements include:

      1. Experience with open source projects, especially those that have many contributors. Ability to independently drive a project forward in the presence of multiple decision makers with conflicting and/or missing requirements is a big plus.
      1. Ability to clearly express oneself in English, especially when using plain text emails and simple markup pages. Ability to quickly comprehend technical English literature. Ability to speak English is not required, but is a plus.
      1. Experience with modern test automation approaches and platforms.
      1. Excellent scripting skills. System administration skills are a plus.
      1. 10+ hours/week availability. Full-time engagement might eventually be possible.
      1. Squid experience is a plus. C++ and/or Javascript knowledge is a plus. This is not a development position, but auditing Squid failures and writing/fixing test cases require development skills.

 1. May I propose non-free and/or closed-source solutions?

   Yes, you may. With all other factors being equal, the Project would prefer a free open-source solution. The Squid Foundation does not currently have enough funds to spend more than ~$100/month on infrastructure payments and currently spends zero. Many commercial services do offer free (as in beer) access to open-source projects but it is your responsibility to carefully research the limits of such offerings because they may not include great features advertised as otherwise available.

 1. What are the payment terms and procedure?

   All prices are listed in US Dollars. The Project can pay via US bank checks, !PayPal, or bank wire transfer (subject to various US banking regulations). The payment will be made within 30 calendar days of the successful pilot completion. Contractors in the US will need to fill out W-9s and will receive 1099s as required by law.

 1. Will Pilot specifications change?

   Yes, Pilot specs are likely to be adjusted until the Pilot is awarded to a contractor. After that, any material changes would be negotiated with the person doing the work, of course.

 1. Will applicants be notified when this page changes?

   No manual notifications are planned. Registered wiki users may [[HelpOnSubscribing|subscribe]] to monitor this page changes. It is applicants responsibility to stay up to date, and we encourage you to use appropriate tools to track this page modifications.

 1. Who determines whether a pilot was successful?

   The Project will determine whether a pilot was successful. If there is no consensus on squid-dev, the Squid Software Foundation board will make that decision.

 1. I emailed my application. Now what?

   You should receive an automated response that your email was sent to the mailing list moderator. No later than a week after the application deadline, you will receive a confirmation that your application has been received and is being reviewed. No later than three weeks after the application deadline, you will receive another email with the Project decision. If you do not hear from us within these periods, please do send another email to troubleshoot. However, sending re-confirmation emails earlier than necessary may decrease your acceptance chances.

 1. How can I recommend somebody else to do the pilots?

   Please show them this page and encourage them to apply! Unfortunately, we may not have enough time to review recommendations and then solicit applications from the recommended folks. It is best if they apply themselves.

 1. Wait a second! Is not this a !DevOps position? Why do you call this work QA?!

    . The three pilot projects and the expected initial work is indeed 90% !DevOps (if you want to use a fresh buzzword) or system administration (if you want to stretch an old term to cover things like CI on some cloud platform). We need an engineer to setup, configure, and occasionally create systems/processes/tools that guard Squid from regressions. Whether that engineer has "!DevOps", "sysadmin", and/or "QA" keywords on the resume is largely irrelevant.

    . For example, Pilot-1 is not about writing or running QA test cases; it is about selecting and then setting up/integrating existing development and testing tools to prevent build failures. Similarly, Pilot-2 and Pilot-3 are not about writing or running test cases either!

    . The long-term expectations for the position is a slow migration towards 75% QA because the systems/processes established in the beginning ought to continue to function increasingly well, with little ongoing maintenance. Thus, the need for DevOps/sysadmin work will diminish (but not disappear). On the other hand, it is also possible that the Squid Project will need both a !DevOps and a QA engineer at that time. However, even at that distant stage, we do ''not'' expect the position to focus on "boring QA" tasks such as testing whether clicking a GUI button 100 times breaks something. The focus would be on triaging complex test failures and possibly scripting new test cases for complex protocols/features (both activities require serious understanding of network protocols, which we cannot expect the candidates for this position to poses, but which they may be able to acquire with time).

    . Our immediate needs are clear. Our predictions regarding the long-term future position requirements may be wrong. We do not know whether we can find a single person that can grow/adjust to stay in sync with the changing position requirements, but that would be ideal.

    . Besides, !DevOps is a part of QA if you believe [[https://en.wikipedia.org/wiki/DevOps#/media/File:Devops.svg|Wikipedia]] ;-).
