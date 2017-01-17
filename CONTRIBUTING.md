# Contributing to this repository

# Table of Contents
1. [Commits, release notes and pull requests](#commits-release-notes-pull-requests)
    1. [Fixing a bug](#fixing-a-bug)
    2. [Commits](#commits)
    3. [Release notes](#release-notes)
    4. [Pull requests](#pull-requests)
        1. [Reviewing pull requests](#reviewing-pull-requests)
        2. [Merging pull requests](#merging-pull-requests)
        3. [Backports](#backports)
2. [Documentation impact](#documentation-impact)
    1. [Documenting your change](#documenting-your-change)
    2. [What to document](#what-to-document)
    3. [How to document] (#what-to-document)
3. [Enabling an upstream project in RPCO](#enabling-upstream-project)
    1. [Integration with OpenStack-Ansible(#integration-with-osa)
    2. [Tech preview vs. fully supported](#tech-preview-vs-fully-supported)
        1. [Tech preview](#tech-preview)
        2. [Fully supported](#fully-supported)
    3. [The details](#the-details)
        1. [Adding the ability to be deployed](#ability-to-deploy)
        2. [Adding the necessary(if any) variables to default variable files](#add-variables)
        3. [Adding ELK configurations](#add-elk-configs)
        4. [Adding the f5 configurations(TBD)](#add-f5-configs)
        5. [Adding MaaS(Monitoring) plugins](#add-maas-plugins)
4. [Triage meetings](#triage-meetings)
    1. [Triage meeting tasks](#triage-meeting-tasks)
5. [Notes](#notes)
6. [Version definitions](#version-definitions)


## Commits, release notes and pull requests<a name="commits-release-notes-pull-requests"></a>
### Fixing a bug<a name="fixing-a-bug"></a>

1. After the bug is triaged and prioritised, make the required changes. New features, breaking changes and other patches of note must include a release note generated using the `reno` tool. Please see `Release Notes` for more information.
2. Push changes directly to a branch on ```rpc-openstack``` in the ```rcbops``` github namespace (rather than a developer's own fork). A pull request is then made from this branch to the ```master``` branch.
3. Unless a bug is specific to a release branch (e.g. ```liberty-12.1```), commit fixes to the ```master``` branch before any potential backports.
4. Bugs meeting backport criteria are backported to the release branches (e.g. ```liberty-12.1```) as appropriate.
5. Github markdown is used to update the original issue with a checklist for tracking which branches have fixes merged.
6. Each time a PR is merged, the associated branch is deleted from ```rpc-openstack```.
7. When all PRs are completed the issue is then closed.

### Commits<a name="commits"></a>

Please avoid the following in a commit:

* Mixing whitespace changes with functional code changes.
* Mixing two unrelated functional changes in the same commit.
* Sending large new features in a single commit.

Expected git commit message structure:

* The first line should be limited to 50 characters, should not end with a full stop and the first word should be capitalised.
* Use the imperative mood in the subject line - e.g. ```Fix a typo in CONTRIBUTING.md```, ```Remove if/else block in myfile.sh```, ```Eat your dinner```.
* Insert a single blank line after the first line.
* Subsequent lines should be wrapped at 72 characters.
* Provide a detailed description of the change in the following lines, using the guidelines in the section below.
* The last line of the commit should be a reference to the issue being fixed using the keyword 'Connects', e.g.
```
Connects https://github.com/rcbops/rpc-openstack/issues/0
```

In your commit message please consider the following points:

* In the commit subject line, provide a brief description of the change.
* The commit message must be descriptive and contain all the information required to fully understand and review the patch.
* Do not assume the reviewer understands what the original problem was.
* Do not assume the reviewer has access to external web services or site.
* Do not assume the code is self-evident or self-documenting.
* Describe why the change is being made.
* If the commit message suggests an improved code structure, you may be able to split this into two or more commits.
* Ensure sufficient information is provided to review your commit.

### Release notes<a name="release-notes"></a>

A release note must be included in your commit for notable changes and new features. It is generated using the Reno tool. To create a release note:

1. [Install the reno tool](http://docs.openstack.org/developer/reno/installation.html).
2. Generate a new release note file. The YAML file is located under `/releasenotes/notes`.

   `$ reno new <version>`
3. Edit the YAML file. The text uses RST formatting.

Each list item must make sense to read without the context of the patch or the repository the patch is being submitted into. The reason for this is that all release notes are consolidated and presented in a long list without reference to the source patch or the context of the repository.

Each note should be brief and to the point. Try to avoid multi-paragraph notes. For features the note should typically refer to documentation for more details. For bug fixes the note can refer to a registered bug for more details.

In most cases only the following sections should be used for new release notes submitted with patches:

* Features - This section should inform the deployer briefly about a new feature and should describe how to use it either by referencing the variables to set or by referring to documentation.
* Issues - This section should inform the deployer about known issues. This may be used when fixing an issue and wanting to inform deployers about a workaround that can be used for versions prior to that which contains the patch that fixes the issue. Issue notes should specifically make mention of what versions of RPCO are affected by the issue.
* Upgrade - This section should inform the deployer about changes which may affect them when upgrading from a previous major or minor version. Typically, these notes would describe changes to default variable values or variables that have been removed.
* Deprecations - If a variable has been deprecated (ideally using the deprecation filter), then it should be communicated through the notes in this section. Note that if a variable has been removed entirely, then it has not been deprecated and the removal should be noted in the upgrade section.

For more information, see the [Reno project documentation](http://docs.openstack.org/developer/reno/index.html).

### Pull requests<a name="pull-requests"></a>

* A pull request (PR) should ideally contain a single commit
* The PR should include an edited `yaml` release note file describing the changes.
* The PR title and message should contain information relevant to why the commit(s) are happening. This can be based off the commit message.
* The PR description should reference the original issue.
* Where absolutely necessary, related commits can be grouped into a single PR, but this should be the exception, not the rule.

#### Reviewing a pull request<a name="reviewing-pull-requests"></a>

When reviewing a PR, please ensure the included commit(s):

* Actually works to fix the issue.
* Passes the gate checks that are configured to run.
* Contains a single commit, which has a commit message describing the changes involved in the patch. On a rare occasion, multiple related commits in the same PR could be considered.
* Includes a YAML release note file which complies with the release notes guidelines described above.
* Does not overreach. Each commit should be self contained to only address the issue at hand (see above).

#### Merging a pull request<a name="merging-pull-requests"></a>

In order for a PR to be merged, the following criteria should be met:

* All gate tests must have passed.
* There must be at least 2 members of the rcbops engineering team review and give the PR a +1 approval using the review guidelines above.
 * Use GitHub's [pull request reviews](https://help.github.com/articles/about-pull-request-reviews/) function so that your comments are collated into a single review.
 * If a patch is being backported, the person doing the backport cannot vote on it, but the original author of the patch can.
* The second +1 reviewer should merge the patch.

#### Backports<a name="backports"></a>
The owner is responsible for backporting the commit if necessary. Backport pull requests must reference the original issue using the 'Connects' keyword.

## Documentation impact<a name="documentation-impact"></a>

### Documenting your change<a name="documenting-your-change"></a>

When there is a doc impact on your change, you have two choices:

1. Submit an issue to [Docs issues](https://github.com/rackerlabs/docs-rpc/issues)
OR
2. Contribute your own doc change to [docs-rpc](https://github.com/rackerlabs/docs-rpc) and tag a relevant docs person for review and merge.

### What to document<a name="what-to-document"></a>

Document changes if:

* There are changes to the way playbooks are run/named
* Changes to the documented configuration files
* New feature
* Change that requires you (as the developer) to take action
* Update impact changes

### How to document<a name="how-to-document"></a>

The documentation work is all done in [this](https://github.com/rackerlabs/docs-rpc) repo.

1. See the [Docs workflow](https://github.com/rackerlabs/docs-rpc/blob/master/GITHUBING.rst) to setup for contribution and
   [here](https://github.com/rackerlabs/docs-rpc/blob/master/CONTRIBUTING.rst) for our Contributor guidelines.
2. Once you have created a pull request, tag the doc team for review. See [Documentation team FAQ](https://github.com/rackerlabs/docs-rackspace/blob/master/doc/contributor-collateral/privatecloud-docteam-FAQ.rst) for clarification on who to contact.
3. Await merge. Respond to any questions/comments/concerns.

Any further questions about our github processes, contributor guidelines, or FAQ about the docs and team, refer to: [Contributor collatoral](https://github.com/rackerlabs/docs-rackspace/tree/master/doc/contributor-collateral)

## Enabling an upstream project in RPCO<a name="enabling-upstream-project"></a>

### Integration with OpenStack-Ansible<a name="integration-with-osa"></a>

Before an OpenStack feature can be integrated into RPCO, it must first be implemented into the OpenStack-Ansible(OSA) project.
For documentation on how to add a service and Ansible role to OpenStack-Ansible, please see [this page](http://docs.openstack.org/developer/openstack-ansible/developer-docs/additional-roles.html).

Once the new project is fully integrated into OpenStack-Ansible, it might not be consumable by RPCO yet. Since RPCO and OSA do not have matching developing cycles, the project will either have to be backported to a stable branch in OSA(unlikely) or will not be included until RPCO moves on to the release with the new project. For example, if the new project is added into the master branch of OSA(currently Otaca), it will not be consumable by RPCO until RPCO's master branch has been modified to consume OSA's Otaca release. It is recommended to start this integration 6-12 months before you intend on releasing the feature in RPC.

### Tech preview vs. fully supported<a name="tech-preview-vs-fully-supported"></a>

#### Tech previews<a name="tech-preview"></a>

When a new OpenStack project or feature is first introduced into RPCO, it will come in as a tech-preview. In order for the project/feature to be qualified as a tech-preview item, it must meet the following criteria:

  * Integration into the OSA project as specified in the above section
  * Ability to be deployed via our bootstrap and deployment scripts(This is currently being changed as part of https://github.com/rcbops/u-suk-dev/issues/834)
  * All necessary addition of variables inserted in either [user_osa_varibles_defaults.yml](https://github.com/rcbops/rpc-openstack/blob/master/rpcd/etc/openstack_deploy/user_osa_variables_defaults.yml) and/or [user_rpco_variables_defaults.yml](https://github.com/rcbops/rpc-openstack/blob/master/rpcd/etc/openstack_deploy/user_rpco_variables_defaults.yml)
  * Integration with RPCO's ELK configurations
  * If the new project has a service that needs to be load-balanced, then f5 support for these services must be added into the rpc_f5 role(TBD).
  * Documentation on how to deploy the feature/project with RPCO

It's also important to note what tech-previews are **not**:

  * Not fully supported by Rackspace Support
  * Not considered stable features/projects
  * Not integrated into RPCO automated testing
  * Not deployed by default
  * May not be implemented with HA

#### Fully supported<a name="fully-supported"></a>

Fully supported features/projects in RPCO must meet the qualifications for a tech preview, plus the following:

  * Must be monitored via a MaaS plugin
  * Must be HA
  * Must be fully integrated with RPCO gate jobs
  * Must be fully supported by Rackspace

### The details<a name="the-details"></a>

#### Adding the ability to be deployed<a name="ability-to-deploy"></a>
#### Adding the necessary(if any) variables to default variable files<a name="add-variables"></a>
#### Adding ELK configurations<a name="add-elk-configs"></a>
#### Adding the f5 configurations(TBD)<a name="add-f5-configs"></a>
#### Adding MaaS(Monitoring) plugins for new services<a name="add-maas-plugins"></a>




## Triage meetings<a name="triage-meetings"></a>
Triage meetings are held on a weekly basis, with ad hoc meetings held as required. Their main purpose is to review what has been achieved since the last meeting and provide an opportunity to discuss specific cards if there is concern about their current priority. The Waffle board is used to provide this information.

### Triage meeting tasks<a name="triage-meeting-tasks"></a>
* Review tasks completed since the last meeting
* Review new issues in the backlog
* Allow the opportunity to discuss the classification of any open issue that has not already been discussed in the meeting, this should not be used as a chance to rehash old arguments but instead to highlight the case for issues where the circumstances have changed.

#### Notes<a name="notes"></a>
- ```master``` branch is always the 'current' branch where development for the next minor or major release is taking place
- Named branches (e.g. ```liberty-12.1```, or ```mitaka-13.2```) are release branches where releases are tagged
- All branches have gating enabled, and patches should not be merged that do not pass gating
- QE testing is only performed on major (e.g. ```12.0.0```) and minor (e.g. ```12.1.0```) releases, not on patch (e.g. ```12.1.5```) releases, which are assumed to be adequately tested by the commit based, and periodic, jenkins gating.

#### Version definitions<a name="version-definitions"></a>

**Major release**

  * OpenStack release
  * Possibly a new feature (?)

**Minor release**

  * Big change within a release
  * Security  - upgrade-impacting
  * Bug fixes - upgrade-impacting
  * Features
  * sha bumps

**Patch release**

  * Security  - non-upgrade-impacting
  * Bug fixes - non-upgrade-impacting
