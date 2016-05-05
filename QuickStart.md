# EVA快速开始

本文档不生动地描述了如何使用EVA，包括了创建一个名为`MSE`的数据集，开始一个项目，添加3个实验，运行项目和回收结果。

- 数据集是一个实例集合，一般由多个文件组成。运行时，每个实例将被依次作为第一个参数传入项目程序。
- 实验指的是，对于特定程序、并行数量、测试集以及参数组合，保存结果的文件夹。
- 项目指的是一个程序（比如某个算法的某个版本编译出来的二进制文件）、指定的并行数量和其对应的所有实验。

简单来说，一个项目程序可以对应多个项目（并行数量不同），一个项目可以对应多个实验（实例集、参数组合不同）。
相同项目下的所有实验，都具有相同的并行数量和项目程序。

EVA对项目程序存在以下**约定**：
- 输入的数据集中的实例文件的绝对文件名（以`/`开头）会被作为第一个参数（`argv[1]`）传入程序。
- 项目程序输出的所有字符都将被认定是对实例文件的解的一部分，包括管道`1`（`stdout`）和`2`（`stderr`）中的所有数据。
- 输出的最后一行为算法对输入实例的解质量的总结，如`argv[1] value time`，其中`value`是解质量，`time`是时间。在运行任务结束时，每个输出的最后一行将被整理成`.sum`文件。

对于项目程序，EVA推荐使用**静态链接**，并且在运行的初期**打印所有传入的参数**，已备后期调阅。


# 部署EVA

- 复制EVA到指定目录，这里假设为`/home/user/EVA`。此时该目录下应有一个`script`文件夹。

- 添加eva到PATH，执行以下命令：
```
echo "PATH=$PATH:/home/user/EVA/script" >> ~/.bashrc
source ~/.bashrc
```

- 执行`eva`命令，应能看到EVA的简略帮助，同时EVA提示config丢失，已重建。

- `cd /home/user/EVA/data`。

- 添加MSE数据集：`mkdir -p MSE/files`

- 拷贝MSE数据集中的实例文件到`/home/user/EVA/data/MSE/files`。提示：这里可以使用`ln`或`ln -s`节约硬盘空间。

- 创建数据集文件清单：
```
cd /home/user/EVA/data/MSE/files
ls * > ../list
```

- 至此，数据集创建完毕。如果需要在该数据集上评测不同项目，无需重新创建数据集。


# 建立一个项目

- 准备一个待测程序，例如`ALG_1.out`。假设该程序位于`/home/user/ALG_1.out`。

- 创建项目，并且指定该项目的并行数量是4个进程。该项目中的每个文件夹都指定了一个测试集和参数组合：
```
cd /home/user/EVA/eval
eva new /home/user/ALG_1.out 4
```

- `eva new`命令会创建`ALG_1-p4`文件夹，并将`ALG_1.out`拷贝至文件夹内。请切入该文件夹：`cd ALG_1-p4`

# 创建实验

这里添加三个实验，第一个实验没有参数，第二个实验的参数是`1 2 3`， 第三个实验的参数是`4 5 6`。
```
eva add MSE
eva add MSE 1 2 3
eva add MSE 4 5 6
```
`eva add`命令需要最少一个参数，即数据集名。
命令执行后，会得到`MSE-0000`、`MSE-0001`、`MSE-0002`三个文件夹。

# 查看实验参数

```
eva show
```

# 运行实验

- 运行当前项目下的所有实验：`eva start`。
假设`MSE`实例集中有一个实例是`a.in`，它在不同实验中被作为输入时，执行的命令如下：

EVA在运行`MSE-0000`时：
```
/home/user/EVA/eval/ALG_1-p4/ALG_1.out /home/user/EVA/data/MSE/files/a.in &> /home/user/EVA/eval/ALG_1-p4/MSE-0000/log/a.in.res
```

EVA在运行`MSE-0001`时：
```
/home/user/EVA/eval/ALG_1-p4/ALG_1.out /home/user/EVA/data/MSE/files/a.in 1 2 3 &> /home/user/EVA/eval/ALG_1-p4/MSE-0001/log/a.in.res
```

EVA在运行`MSE-0002`时：
```
/home/user/EVA/eval/ALG_1-p4/ALG_1.out /home/user/EVA/data/MSE/files/a.in 4 5 6 &> /home/user/EVA/eval/ALG_1-p4/MSE-0002/log/a.in.res
```

- 待EVA退出，此时所有结果都已经准备就绪，在`MSE-000x/ALG_1-p4--MSE-000x--machine.sum`中。
该`.sum`文件即为该实验下所有输出的最后一行的汇总。
其中`x`为实验序号，`machine`为机器名。

`machine`会在第一次运行`eva`时，被写入到`EVA/script/config`中，默认值为`hostname`命令的输出。
`machine`被设计为区分来自不同实验机的`.sum`文件，即使它们被统一拷贝至同一个文件夹也不会重名。

# 实验收尾

- 汇总结果，将所有结果统一复制到`10.0.0.2`，使用`user`用户名登录：`eva scp MSE* user@10.0.0.2:`。当然这里你也可以复制到本地目录，如`/tmp/res`：`eva scp MSE* /tmp/res`。

- 如需压缩，请在`/home/user/EVA/eval/ALG_1-p4/`目录中执行`eva xz`命令，或在`/home/user/EVA/eval/`目录中执行`eva xz ALG_1-p4`命令。
压缩将采用`xz`，请确保`xz`已经安装。
压缩后，`.res`文件将变为`.res.xz`。
如需解压，请使用`eva unxz`。
