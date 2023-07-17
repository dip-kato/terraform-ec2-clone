# terraform-ec2-clone
**EC2のクローンツール**

# なにこれ？

EC2をパッとクローンする方法を探していたところ、terraformで複製できるリポジトリを発見！

https://github.com/AKSarav/terraform-ec2-clone

ただ、これだとインスタンスIDを調べたりめんどくさかったのでpecoを使って魔改造してみた

# こんなかんじでうごく

シェル叩くと

```
./clone.sh 
```

~/.aws/credentialsを見に行ってそこにあるプロファイル一覧を取得(今更credentials使う？というツッコミはありますよね、、)

出てくるプロファイルを選択すると自動的にEC2インスタンスの一覧を取得してpecoから選べます(pecoなので入力保管の検索もできる！)

インスタンス名を選ぶとクローンが走ります

```
(略)
aws_ami_from_instance.sourceami: Creating...
aws_ami_from_instance.sourceami: Still creating... [10s elapsed]
aws_ami_from_instance.sourceami: Still creating... [20s elapsed]
aws_ami_from_instance.sourceami: Still creating... [6m0s elapsed]
aws_ami_from_instance.sourceami: Still creating... [6m10s elapsed]
aws_ami_from_instance.sourceami: Still creating... [6m20s elapsed]
aws_ami_from_instance.sourceami: Still creating... [6m30s elapsed]
aws_ami_from_instance.sourceami: Still creating... [6m40s elapsed]
aws_ami_from_instance.sourceami: Still creating... [6m50s elapsed]
aws_ami_from_instance.sourceami: Creation complete after 6m58s [id=ami-07cf3719a40f167ea]
aws_instance.newinstance: Creating...
aws_instance.newinstance: Still creating... [10s elapsed]
aws_instance.newinstance: Creation complete after 15s [id=i-0e4114627d45e0620]
```

AMIとNAMEタグに**-clone**が付いたEC2ができる。さらにAMIは複製後に自動的に消される
**超絶便利！セキュリティグループや、サブネットまで複製されます！！**
terraform管理しているのでdestroyも効くので作り直しも簡単!!

# 弱点

①publicなのはグローバルIPがつかない
②タグが複製されない
③sshの鍵が空になる
