# Cold review

For a change to a doc, template or config. A reviewer who has not seen the work that produced the change reads only the files and answers the three questions below. The author's reread runs on the context that produced the text and does not see what only that context explains; a reader without it does.

Give the reviewer the repository, the changed files, and two or three files of the same kind next to them: the neighbouring doc, the template it was made from, the checklist beside it. Those files are the style the change is held to. Do not give the issue, the PR, the commit messages, or any conversation. An agent gets this file and the paths as its whole prompt. In config, a sentence means a comment or a key name.

## Questions

1. Could the owner of this repository have written every changed sentence about the repository itself, with no outside prompting? Flag any sentence that reads as if it answers a question asked elsewhere, or that references a motive, person or situation the repository does not record. For each rule the change adds, say whether the problem it solves is stated or anchored in the repository, or reads like a reaction to an event the repository does not show.
2. Does any changed sentence need a conversation the reviewer has not seen to make sense? Flag any sentence a newcomer reading only the repository would find unexplained, or any term used without the repository defining it.
3. Does any changed sentence break the style of the files given next to it, or contradict another sentence in the repository?

## Findings

Each finding: the file, the sentence quoted, the problem, a rewrite. Only findings; a question with none says so in one line. The reviewer edits nothing.

A finding is fixed before the PR opens, or the PR's What and why says why not.
