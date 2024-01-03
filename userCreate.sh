#!/bin/bash

echo "Ingrese el nombre de usuario."
read username

while [ -z "$username" ]; do
	echo "Inserte un nombre válido."
	read username
done

echo "A continuación, ingrese una dirección válida de mail."
read email

while [[ ! "$email" =~ ^[a-zA-Z0-9._%+-]{1,20}+@[a-zA-Z0-9._%+-]{1,10}\.[a-zA-Z]{2,3}$ ]]; do
	echo "La dirección de correo no es válida. Inténtalo de nuevo."
	read email
done

echo "Ahora, inserta tu departamento de trabajo."
read grupo

while [ -z "$grupo" ]; do
	echo "Inserte un grupo."
	read grupo
done

if grep -q "^$grupo:" /etc/group; then
	echo "Añadido al grupo $grupo."
else
	sudo groupadd "$grupo"
	echo "Grupo creado correctamente."
fi

echo "Ahora, inserte la contraseña de usuario."
read -s contra
while [ -z "$contra" ]; do
	echo "Inserte una contraseña."
	read -s contra
done
echo "Inserte de nuevo la contraseña."
read -s recontra
while [ -z "$recontra" ]; do
	echo "Pero che. La idea es que insertes algo."
	read -s recontra
done

while [ "$contra" != "$recontra" ]; do
	echo "Mal, mal. No coinciden, inserte la contraseña de nuevo."
	read -s contra
	echo "Confirme dicha contraseña."
	read -s recontra
done

sudo useradd -m -d "/home/$username" -s /bin/bash -g "$grupo" "$username" >> ./userLog.txt

sudo chown "$username:$grupo" "/home/$username" >> ./userLog.txt
sudo chmod 750 "/home/$username" >> ./userLog.txt

echo "$username:$contra" | sudo chpasswd >> ./userLog.txt

sudo usermod -c "$email" "$username" >> ./userLog.txt

sudo setquota -u $username 151M 201M 0 0 / >> ./userLog.txt
sudo chage -M 30 $username >> ./userLog.txt
echo "Usuario creado exitosamente. Nombre: $username, correo: $email, grupo: $grupo, contraseña: No te preocupes, no vamos a revelarla."
echo "$username | $email | $grupo | $contra" >> ./userLog.txt
