#!/bin/zsh

# thx to https://piechowski.io/post/git-commands-before-reading-code/ and AI for slop emojis
function pio_git_stats() {
    echo "========================================="
    echo "       GIT REPOSITORY AT A GLANCE        "
    echo "========================================="

    echo -e "\n🔥 WHAT CHANGES THE MOST (Top 20 high-churn files in the last year):"
    git log --format=format: --name-only --since="1 year ago" | awk NF | sort | uniq -c | sort -nr | head -20

    echo -e "\n👷 WHO BUILT THIS (Contributors ranked by commit count):"
    git shortlog -sn --no-merges

    echo -e "\n🐛 WHERE BUGS CLUSTER (Top 20 files matching fix/bug/broken):"
    git log -i -E --grep="fix|bug|broken" --name-only --format='' | awk NF | sort | uniq -c | sort -nr | head -20

    echo -e "\n📈 IS THIS PROJECT ACCELERATING OR DYING? (Commits per month):"
    git log --format='%ad' --date=format:'%Y-%m' | sort | uniq -c

    echo -e "\n🚨 HOW OFTEN IS THE TEAM FIREFIGHTING? (Revert/hotfix/rollback in the last year):"
    git log --oneline --since="1 year ago" | grep -iE 'revert|hotfix|emergency|rollback' || echo "(No firefighting commits found)"

    echo -e "\n========================================="
}
