#!/bin/bash

cat ./repo.list | awk '{
	repo_git = $1;
	split(repo_git,ary,"/");
	split(ary[5],ary2,".");
    repo_dir = ary[4]"/"ary2[1];

    # コマンドを生成
	command = sprintf("if [ ! -d ./%s ]; then git clone %s ./%s; fi; " , repo_dir,repo_git,repo_dir);
    # コマンドを実行して結果を取得
    buf = system(command);
    # stream をclose
    close(command);
}'
