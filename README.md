# terraform-ec2-clone

**terraformを使ったEC2の簡単クローンツール**

# なにこれ？

EC2をパッとクローンする方法を探していたところterraformで複製できるリポジトリを発見！<br>
<br>
https://github.com/AKSarav/terraform-ec2-clone<br>
<br>
ただ、これだとインスタンスIDを調べたりめんどくさかったのでpecoを使って**魔改造**してみた<br>

# セットアップ

- chmod 755 clone.shとかで実行権付けてください
- ユーザーのホームディレクトリにterraformの実行バイナリを置いてください。（パス通ったとこにあるならシェル内の~/を消してもらっても良い）
- tmp_providersファイル内のリージョンの定義をクローンしたいEC2があるリージョンに書き換えてください
  - region  = "ap-northeast-1" を "us-east-2"とかに

# こんなかんじでうごく

シェル叩くと<br>

```
./clone.sh 
```

~/.aws/credentialsを見に行ってそこにあるプロファイル一覧を取得(今更credentials使う？というツッコミはありますよね、、)<br>

![1](https://github.com/dip-kato/terraform-ec2-clone/assets/95202883/6d16e54b-4513-4530-9a92-d99cbdb87707)

出てくるプロファイルを選択すると自動的にEC2インスタンスの一覧を取得してpecoから選べます<br>

![2](https://github.com/dip-kato/terraform-ec2-clone/assets/95202883/bc2c8d25-57b5-408c-b449-4ced2a63ee16)

pecoなので入力保管の検索もできる！<br>

![3](https://github.com/dip-kato/terraform-ec2-clone/assets/95202883/d17208b2-7221-4c12-adf7-f184507c2075)

インスタンス名を選ぶとクローンが走ります<br>

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

AMIとNAMEタグに**-clone**が付いたEC2ができる。さらにAMIは複製後に自動的に消される<br>

![4](https://github.com/dip-kato/terraform-ec2-clone/assets/95202883/f19177e5-f5ff-47ed-9669-09a880a7cb35)

**超絶便利！セキュリティグループや、サブネットまで複製されます！！**<br>
terraform管理しているのでdestroyも効くので作り直しも簡単!!<br>

```
DIP22-M10011:terraform-ec2-clone yasutaka-kato$ ~/terraform destroy
(略)
Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

aws_instance.newinstance: Destroying... [id=i-0e4114627d45e0620]
aws_instance.newinstance: Still destroying... [id=i-0e4114627d45e0620, 10s elapsed]
aws_instance.newinstance: Still destroying... [id=i-0e4114627d45e0620, 20s elapsed]
aws_instance.newinstance: Destruction complete after 30s

Destroy complete! Resources: 1 destroyed.
```

# 弱点

①publicなのはグローバルIPがつかない<br>
②タグが複製されない<br>
③sshの鍵が空になる<br>
