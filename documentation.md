# Technische Dokumentation: ECS-Cluster-Bereitstellung auf AWS

## Übersicht

Diese Dokumentation bietet eine schrittweise Anleitung zur Bereitstellung eines Amazon Elastic Container Service (ECS)-Clusters auf AWS. Der ECS-Cluster ist darauf ausgelegt, zwei Docker-Container zu hosten: einen für einen Socket-Server und einen für eine Connect4-Spielanwendung. Die Container werden als Fargate-Aufgaben bereitgestellt und sind über einen Application Load Balancer (ALB) zugänglich.

## Verwendete AWS-Dienste

1. **Amazon VPC (Virtual Private Cloud):**
    - Ein benutzerdefiniertes VPC mit dem CIDR-Block `10.0.0.0/16` wird erstellt, um die Netzwerkumgebung zu isolieren.
    - Es werden zwei Subnetze erstellt: ein privates (`10.0.1.0/24`) und ein öffentliches (`10.0.0.0/24`).
    - Ein Internet Gateway ist mit dem VPC verbunden, um den Internetzugang zu ermöglichen.

2. **Amazon Internet Gateway:**
    - Ermöglicht eine Verbindung zwischen dem VPC und dem Internet.
    - Ist mit dem Haupt-VPC verbunden, um die Internetkommunikation zu ermöglichen.

3. **Amazon Subnets:**
    - Es werden zwei Subnetze erstellt - eins öffentlich und eins privat.
    - Das öffentliche Subnetz (`10.0.0.0/24`) ist für Ressourcen vorgesehen, die Internetzugang benötigen.
    - Das private Subnetz (`10.0.1.0/24`) ist für Ressourcen gedacht, die nicht direkt aus dem Internet erreichbar sein sollen.

4. **Amazon Route Tables:**
    - Zwei Routen-Tabellen - eine für das öffentliche Subnetz und eine für das private Subnetz.
    - Die öffentliche Routen-Tabelle hat eine Standardroute über das Internet Gateway.
    - Die private Routen-Tabelle hat eine Standardroute über ein NAT Gateway.

5. **Amazon NAT Gateway:**
    - Ermöglicht ausgehenden Internetzugang für Ressourcen im privaten Subnetz.
    - Ist mit dem öffentlichen Subnetz verbunden und verfügt über eine Elastic IP (EIP).

6. **Amazon Security Groups:**
    - Drei Sicherheitsgruppen werden erstellt:
        - `alb` für den ALB mit eingehenden Regeln für den Verkehr auf den Ports 80 und 3001.
        - `ecs_tasks` für ECS-Aufgaben mit eingehenden Regeln für den Verkehr auf den Ports 80 und 3001.
        - `web_sg` für Web-Instanzen mit eingehender Regel für den Verkehr auf Port 80.

7. **Amazon Elastic Load Balancer (ALB):**
    - Ein ALB mit dem Namen `ecs-lb` wird erstellt, um eingehenden Verkehr zu verteilen.
    - Konfiguriert als Application Load Balancer auf Port 80.
    - Ist mit der Sicherheitsgruppe `web_sg` verbunden und erstreckt sich über öffentliche und private Subnetze.

8. **Amazon ECS Cluster:**
    - Ein ECS-Cluster wird erstellt und entsprechend der bereitgestellten Variable benannt.
    - Container Insights werden aktiviert, um eine Überwachung zu ermöglichen.

9. **Amazon ECS Task Definition:**
    - Definiert die Parameter für die Ausführung von Docker-Containern als Fargate-Aufgaben.
    - Zwei Container werden definiert - einer für den Socket-Server und einer für die Connect4-Anwendung.
    - Die Container-Definitionen enthalten Details zu den Images, Portzuordnungen und Ressourcenbeschränkungen.

10. **Amazon ECS Service:**
    - Verwaltet und bereitet Aufgaben basierend auf der definierten Aufgaben-Definition.
    - Ist mit dem ECS-Cluster, der Aufgaben-Definition und der ALB-Zielgruppe verbunden.
    - Konfiguriert für die Ausführung auf Fargate, um eine serverlose Containerausführung sicherzustellen.

## Bereitstellungsworkflow

1. **VPC-Einrichtung:**
    - Ein benutzerdefiniertes VPC mit dem CIDR-Block `10.0.0.0/16` wird erstellt.
    - Subnetze (öffentlich und privat) werden innerhalb des VPCs eingerichtet.

2. **Internetverbindung:**
    - Das Internet Gateway wird mit dem VPC verbunden, um den Internetzugang zu ermöglichen.
    - Öffentliche und private Routen-Tabellen werden entsprechend konfiguriert.

3. **Sicherheitsgruppen:**
    - Sicherheitsgruppen werden für ALB, ECS-Aufgaben und Web-Instanzen definiert.

4. **ALB-Konfiguration:**
    - Ein ALB mit dem Namen `ecs-lb` wird erstellt, ist mit der Sicherheitsgruppe `web_sg` verbunden.
    - Ein ALB-Listener wird auf Port 80 konfiguriert, der den Verkehr an die ECS-Zielgruppe weiterleitet.

5. **ECS-Cluster-Einrichtung:**
    - Ein ECS-Cluster wird mit aktivierten Container Insights erstellt.

6. **Aufgaben-Definition:**
    - Die ECS-Aufgaben-Definition wird definiert, um den Socket-Server und die Connect4-Anwendung auszuführen.

7. **Service-Konfiguration:**
    - Der ECS-Service wird so konfiguriert, dass er den Fargate-Starttyp verwendet.
    - Die ALB-Zielgruppe ist mit dem ECS-Service verbunden.

8. **Bereitstellung:**
    - Der ECS-Service wird bereitgestellt, indem Fargate-Aufgaben im ECS-Cluster gestartet werden.
    - Der ALB verteilt den eingehenden Verkehr auf die bereitgestellten Aufgaben.

9. **Zugriff auf Ressourcen:**
    - Die Connect4-Anwendung und der Socket-Server sind über den öffentlichen Endpunkt des ALB zugänglich.

## Fazit

Diese Dokumentation bietet eine umfassende Anleitung zur Bereitstellung eines ECS-Clusters auf AWS und umfasst die Einrichtung des VPCs, die Internetverbindung, Sicherheitskonfigurationen, die ALB-Einrichtung, die Bereitstellung von ECS-Cluster- und -Service sowie den Zugriff auf bereitgestellte Ressourcen. Der beschriebene Workflow gewährleistet eine gut strukturierte und sichere Bereitstellung containerisierter Anwendungen auf AWS. Für weitere Details und Anpassungen siehe das bereitgestellte Terraform-Skript (`ecs_cluster/main.tf`