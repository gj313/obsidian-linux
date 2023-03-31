#! /bin/bash

_pkgname=obsidian

pkgname="${_pkgname}"-appimage
pkgver=1.1.16
pkgrel=1
pkgdesc="Obsidian is a powerful knowledge base that works on top of a local folder of plain text Markdown files"
arch=('x86_64' 'aarch64')
url="https://obsidian.md/"
license=('custom:Commercial')
depends=('zlib' 'hicolor-icon-theme' 'fuse2')
provides=("${_pkgname}")
conflicts=("${_pkgname}" 'obsidian' 'obsidian-insider')
options=(!strip)
_appimage="${pkgname}-${pkgver}.AppImage"
source_x86_64=("${_appimage}::https://github.com/obsidianmd/obsidian-releases/releases/download/v${pkgver}/Obsidian-${pkgver}.AppImage")
source_aarch64=("${_appimage}::https://github.com/obsidianmd/obsidian-releases/releases/download/v${pkgver}/Obsidian-${pkgver}-arm64.AppImage")
noextract=("${_appimage}")
sha256sums_x86_64=('45995b19b417087559fe9c1d86df7b456842cdd58281e641fc492006ba2bb2be')
sha256sums_aarch64=('d1f45f5c784470008904bccf0024c097a5a59961acfc4cca627063f919ea3476')


file="https://github.com/obsidianmd/obsidian-releases/releases/download/v${pkgver}/Obsidian-${pkgver}.AppImage"
wget $file -O $_appimage

chmod +x "${_appimage}"
./"${_appimage}" --appimage-extract

# Adjust .desktop so it will work outside of AppImage container
sed -i -E "s|Exec=AppRun|Exec=env DESKTOPINTEGRATION=false /usr/bin/${_pkgname} %u|"\
    "squashfs-root/${_pkgname}.desktop"
# Fix permissions; .AppImage permissions are 700 for all directories
chmod -R a-x+rX squashfs-root/usr


# AppImage
sudo install -Dm755 "${_appimage}" "/opt/${pkgname}/${pkgname}.AppImage"

# Desktop file
sudo install -Dm644 "squashfs-root/${_pkgname}.desktop"\
        "/usr/share/applications/${_pkgname}.desktop"

# Icon images
sudo cp -a "squashfs-root/usr/share/icons" "/usr/share/"

# Symlink executable
sudo ln -s "/opt/${pkgname}/${pkgname}.AppImage" "/usr/bin/${_pkgname}"

