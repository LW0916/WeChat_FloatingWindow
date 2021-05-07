#!/bin/sh

# 使用方法:
# step1: 将该脚本放在工程的根目录下（跟.xcworkspace文件or .xcodeproj文件同目录）
# step2: 根据情况修改下面的参数
# step3: 打开终端，执行脚本。（输入sh，然后将脚本文件拉到终端，会生成文件路径，然后enter就可）

# =============项目自定义部分(自定义好下列参数后再执行该脚本)=================== #
echo "请选择打包方式 ? [ 1:development 2:ad-hoc ]"

read number
while([[ $number != 1 ]] && [[ $number != 2 ]])
do
echo "Error! Should enter 1 or 2"
echo "请选择打包方式 ? [ 1:development 2:ad-hoc ]"
read number
done

# .xcworkspace的名字，必填
workspace_name="WeChat_FloatingWindow"

# 指定项目的scheme名称（也就是工程的target名称），必填
scheme_name="WeChat_FloatingWindow"

# 指定要打包编译的方式 : Release,Debug。一般用Release。必填
build_configuration="Release"

# method，打包的方式。方式分别为 development, ad-hoc 。必填
method="ad-hoc"

#  下面两个参数只是在手动指定Pofile文件的时候用到，如果使用Xcode自动管理Profile,直接留空就好
# (跟method对应的)mobileprovision文件名，需要先双击安装.mobileprovision文件.手动管理Profile时必填
mobileprovision_name=""

# 项目的bundleID，手动管理Profile时必填
bundle_identifier="com.bonc.MovePortalBase.UNICOM.SH"

if [ $number == 1 ];then
build_configuration="Debug"
method="development"
else
build_configuration="Release"
method="ad-hoc"
fi

echo "--------------------脚本配置参数检查--------------------"
echo "\033[33;1mworkspace_name = ${workspace_name}"
echo "scheme_name = ${scheme_name}"
echo "build_configuration = ${build_configuration}"
echo "bundle_identifier = ${bundle_identifier}"
echo "method = ${method}"
echo "mobileprovision_name = ${mobileprovision_name} \033[0m"


# =======================脚本的一些固定参数定义(无特殊情况不用修改)====================== #

# 获取当前脚本所在目录
script_dir="$( cd "$( dirname "$0"  )" && pwd  )"
# 工程根目录
project_dir=$script_dir

# 指定输出导出文件夹路径
export_path="$project_dir/Build"
# 指定输出归档文件路径
export_archive_path="$export_path/$scheme_name.xcarchive"
# 指定输出ipa文件夹路径
export_ipa_path="$export_path/"
# 指定导出ipa包需要用到的plist配置文件的路径
export_options_plist_path="$project_dir/ExportOptions.plist"


echo "--------------------脚本固定参数检查--------------------"
echo "\033[33;1mproject_dir = ${project_dir}"
echo "export_path = ${export_path}"
echo "export_archive_path = ${export_archive_path}"
echo "export_ipa_path = ${export_ipa_path}"
echo "export_options_plist_path = ${export_options_plist_path}\033[0m"

# =======================自动打包部分(无特殊情况不用修改)====================== #

echo "------------------------------------------------------"
echo "\033[32m开始构建项目  \033[0m"
# 进入项目工程目录
cd ${project_dir}

# 指定输出文件目录不存在则创建
if [ -d "$export_path" ];
then rm -rf "$export_path"
fi

# 编译前清理工程
xcodebuild clean -workspace ${workspace_name}.xcworkspace \
                 -scheme ${scheme_name} \
                 -configuration ${build_configuration}

xcodebuild archive -workspace ${workspace_name}.xcworkspace \
                   -scheme ${scheme_name} \
                   -configuration ${build_configuration} \
                   -archivePath ${export_archive_path}

#  检查是否构建成功
#  xcarchive 实际是一个文件夹不是一个文件所以使用 -d 判断
if [ -d "$export_archive_path" ] ; then
    echo "\033[32;1m项目构建成功 🚀 🚀 🚀  \033[0m"
else
    echo "\033[31;1m项目构建失败 😢 😢 😢  \033[0m"
    exit 1
fi
echo "------------------------------------------------------"

echo "\033[32m开始导出ipa文件 \033[0m"


# 先删除export_options_plist文件
if [ -f "$export_options_plist_path" ] ; then
    #echo "${export_options_plist_path}文件存在，进行删除"
    rm -f $export_options_plist_path
fi

# 根据参数生成export_options_plist文件
/usr/libexec/PlistBuddy -c  "Add :method String ${method}"  $export_options_plist_path
/usr/libexec/PlistBuddy -c  "Add :provisioningProfiles:"  $export_options_plist_path
/usr/libexec/PlistBuddy -c  "Add :provisioningProfiles:${bundle_identifier} String ${mobileprovision_name}"  $export_options_plist_path
/usr/libexec/PlistBuddy -c  "Add :compileBitcode bool NO" $export_options_plist_path


xcodebuild  -exportArchive \
            -archivePath ${export_archive_path} \
            -exportPath ${export_ipa_path} \
            -exportOptionsPlist ${export_options_plist_path} \
            -allowProvisioningUpdates

# 检查文件是否存在
if [ -f "$export_ipa_path/$scheme_name.ipa" ] ; then
    echo "\033[32;1m导出 ${scheme_name}.ipa 包成功 🎉  🎉  🎉   \033[0m"
    open $export_path
else
    echo "\033[31;1m导出 ${scheme_name}.ipa 包失败 😢 😢 😢     \033[0m"
    exit 1
fi

# 删除export_options_plist文件（中间文件）
if [ -f "$export_options_plist_path" ] ; then
    #echo "${export_options_plist_path}文件存在，准备删除"
    rm -f $export_options_plist_path
fi

# 输出打包总用时
echo "\033[36;1m使用AutoPackageScript打包总用时: ${SECONDS}s \033[0m"

# 上传到xxx
# 这里上传到蒲公英、还是firm、还是自己搭建的filehub、还是什么，请大家自行决定吧

exit 0
