-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb is
end project_tb;

architecture project_tb_arch of project_tb is
    constant CLOCK_PERIOD : time := 20 ns;
    signal tb_clk : std_logic := '0';
    signal tb_rst, tb_start, tb_done : std_logic;
    signal tb_add : std_logic_vector(15 downto 0);
    signal tb_k   : std_logic_vector(9 downto 0);

    signal tb_o_mem_addr, exc_o_mem_addr, init_o_mem_addr : std_logic_vector(15 downto 0);
    signal tb_o_mem_data, exc_o_mem_data, init_o_mem_data : std_logic_vector(7 downto 0);
    signal tb_i_mem_data : std_logic_vector(7 downto 0);
    signal tb_o_mem_we, tb_o_mem_en, exc_o_mem_we, exc_o_mem_en, init_o_mem_we, init_o_mem_en : std_logic;

    type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (OTHERS => "00000000");

constant SCENARIO_LENGTH : integer := 417;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (224,0,0,0,0,0,129,0,163,0,217,0,190,0,10,0,66,0,7,0,36,0,88,0,161,0,17,0,0,0,56,0,248,0,217,0,137,0,8,0,148,0,117,0,187,0,0,0,118,0,0,0,0,0,224,0,99,0,78,0,226,0,0,0,133,0,57,0,59,0,19,0,20,0,95,0,134,0,0,0,0,0,0,0,37,0,26,0,32,0,177,0,35,0,25,0,198,0,146,0,164,0,46,0,191,0,130,0,85,0,57,0,244,0,0,0,214,0,0,0,63,0,30,0,0,0,234,0,0,0,135,0,193,0,0,0,109,0,227,0,195,0,214,0,118,0,67,0,65,0,88,0,212,0,42,0,230,0,13,0,151,0,91,0,59,0,23,0,28,0,124,0,221,0,243,0,203,0,0,0,41,0,97,0,12,0,55,0,111,0,87,0,152,0,234,0,14,0,146,0,29,0,0,0,0,0,0,0,246,0,11,0,160,0,114,0,10,0,212,0,31,0,172,0,22,0,72,0,111,0,209,0,0,0,231,0,123,0,172,0,23,0,110,0,0,0,0,0,0,0,12,0,53,0,18,0,67,0,88,0,135,0,144,0,0,0,221,0,252,0,56,0,8,0,35,0,218,0,97,0,211,0,250,0,113,0,2,0,0,0,163,0,50,0,22,0,239,0,25,0,91,0,0,0,219,0,0,0,95,0,98,0,13,0,199,0,237,0,21,0,61,0,243,0,238,0,141,0,219,0,49,0,4,0,199,0,176,0,176,0,0,0,0,0,153,0,95,0,212,0,187,0,161,0,193,0,0,0,67,0,0,0,0,0,0,0,130,0,156,0,184,0,39,0,200,0,0,0,20,0,0,0,156,0,73,0,94,0,252,0,210,0,0,0,236,0,73,0,96,0,0,0,215,0,237,0,0,0,255,0,5,0,170,0,119,0,8,0,29,0,98,0,0,0,0,0,0,0,17,0,49,0,1,0,220,0,220,0,42,0,105,0,255,0,28,0,74,0,101,0,107,0,110,0,0,0,0,0,0,0,96,0,254,0,227,0,0,0,0,0,38,0,16,0,126,0,89,0,87,0,204,0,204,0,0,0,190,0,189,0,231,0,222,0,160,0,50,0,0,0,195,0,148,0,143,0,0,0,0,0,0,0,12,0,62,0,49,0,0,0,0,0,0,0,197,0,0,0,0,0,235,0,98,0,0,0,170,0,192,0,18,0,0,0,90,0,62,0,23,0,140,0,115,0,94,0,0,0,7,0,145,0,60,0,0,0,67,0,137,0,130,0,124,0,0,0,0,0,29,0,60,0,130,0,168,0,36,0,0,0,150,0,134,0,163,0,229,0,110,0,69,0,111,0,122,0,41,0,84,0,171,0,0,0,0,0,24,0,161,0,69,0,216,0,253,0,14,0,1,0,26,0,192,0,0,0,241,0,137,0,114,0,156,0,37,0,11,0,73,0,2,0,0,0,136,0,88,0,217,0,0,0,219,0,113,0,46,0,13,0,0,0,65,0,181,0,69,0,0,0,46,0,0,0,227,0,252,0,0,0,204,0,42,0,247,0,15,0,163,0,178,0,0,0,222,0,119,0,77,0,159,0,0,0,3,0,183,0,0,0,32,0,0,0,155,0,164,0,52,0,38,0,137,0,75,0,0,0,227,0,249,0,41,0,0,0,0,0,156,0,56,0,84,0,0,0,40,0,127,0,19,0,23,0,0,0,43,0,218,0,10,0,0,0,0,0,138,0,98,0,58,0,161,0,242,0,204,0,103,0,10,0,149,0,227,0,146,0,35,0,148,0,145,0,41,0,205,0,47,0,148,0,145,0,122,0,81,0,140,0,204,0,249,0,2,0,241,0,5,0,36,0,126,0);
signal scenario_full  : scenario_type := (224,31,224,30,224,29,129,31,163,31,217,31,190,31,10,31,66,31,7,31,36,31,88,31,161,31,17,31,17,30,56,31,248,31,217,31,137,31,8,31,148,31,117,31,187,31,187,30,118,31,118,30,118,29,224,31,99,31,78,31,226,31,226,30,133,31,57,31,59,31,19,31,20,31,95,31,134,31,134,30,134,29,134,28,37,31,26,31,32,31,177,31,35,31,25,31,198,31,146,31,164,31,46,31,191,31,130,31,85,31,57,31,244,31,244,30,214,31,214,30,63,31,30,31,30,30,234,31,234,30,135,31,193,31,193,30,109,31,227,31,195,31,214,31,118,31,67,31,65,31,88,31,212,31,42,31,230,31,13,31,151,31,91,31,59,31,23,31,28,31,124,31,221,31,243,31,203,31,203,30,41,31,97,31,12,31,55,31,111,31,87,31,152,31,234,31,14,31,146,31,29,31,29,30,29,29,29,28,246,31,11,31,160,31,114,31,10,31,212,31,31,31,172,31,22,31,72,31,111,31,209,31,209,30,231,31,123,31,172,31,23,31,110,31,110,30,110,29,110,28,12,31,53,31,18,31,67,31,88,31,135,31,144,31,144,30,221,31,252,31,56,31,8,31,35,31,218,31,97,31,211,31,250,31,113,31,2,31,2,30,163,31,50,31,22,31,239,31,25,31,91,31,91,30,219,31,219,30,95,31,98,31,13,31,199,31,237,31,21,31,61,31,243,31,238,31,141,31,219,31,49,31,4,31,199,31,176,31,176,31,176,30,176,29,153,31,95,31,212,31,187,31,161,31,193,31,193,30,67,31,67,30,67,29,67,28,130,31,156,31,184,31,39,31,200,31,200,30,20,31,20,30,156,31,73,31,94,31,252,31,210,31,210,30,236,31,73,31,96,31,96,30,215,31,237,31,237,30,255,31,5,31,170,31,119,31,8,31,29,31,98,31,98,30,98,29,98,28,17,31,49,31,1,31,220,31,220,31,42,31,105,31,255,31,28,31,74,31,101,31,107,31,110,31,110,30,110,29,110,28,96,31,254,31,227,31,227,30,227,29,38,31,16,31,126,31,89,31,87,31,204,31,204,31,204,30,190,31,189,31,231,31,222,31,160,31,50,31,50,30,195,31,148,31,143,31,143,30,143,29,143,28,12,31,62,31,49,31,49,30,49,29,49,28,197,31,197,30,197,29,235,31,98,31,98,30,170,31,192,31,18,31,18,30,90,31,62,31,23,31,140,31,115,31,94,31,94,30,7,31,145,31,60,31,60,30,67,31,137,31,130,31,124,31,124,30,124,29,29,31,60,31,130,31,168,31,36,31,36,30,150,31,134,31,163,31,229,31,110,31,69,31,111,31,122,31,41,31,84,31,171,31,171,30,171,29,24,31,161,31,69,31,216,31,253,31,14,31,1,31,26,31,192,31,192,30,241,31,137,31,114,31,156,31,37,31,11,31,73,31,2,31,2,30,136,31,88,31,217,31,217,30,219,31,113,31,46,31,13,31,13,30,65,31,181,31,69,31,69,30,46,31,46,30,227,31,252,31,252,30,204,31,42,31,247,31,15,31,163,31,178,31,178,30,222,31,119,31,77,31,159,31,159,30,3,31,183,31,183,30,32,31,32,30,155,31,164,31,52,31,38,31,137,31,75,31,75,30,227,31,249,31,41,31,41,30,41,29,156,31,56,31,84,31,84,30,40,31,127,31,19,31,23,31,23,30,43,31,218,31,10,31,10,30,10,29,138,31,98,31,58,31,161,31,242,31,204,31,103,31,10,31,149,31,227,31,146,31,35,31,148,31,145,31,41,31,205,31,47,31,148,31,145,31,122,31,81,31,140,31,204,31,249,31,2,31,241,31,5,31,36,31,126,31);

    signal memory_control : std_logic := '0';
    
    constant SCENARIO_ADDRESS : integer := 1234;

    component project_reti_logiche is
        port (
                i_clk : in std_logic;
                i_rst : in std_logic;
                i_start : in std_logic;
                i_add : in std_logic_vector(15 downto 0);
                i_k   : in std_logic_vector(9 downto 0);
                
                o_done : out std_logic;
                
                o_mem_addr : out std_logic_vector(15 downto 0);
                i_mem_data : in  std_logic_vector(7 downto 0);
                o_mem_data : out std_logic_vector(7 downto 0);
                o_mem_we   : out std_logic;
                o_mem_en   : out std_logic
        );
    end component project_reti_logiche;

begin
    UUT : project_reti_logiche
    port map(
                i_clk   => tb_clk,
                i_rst   => tb_rst,
                i_start => tb_start,
                i_add   => tb_add,
                i_k     => tb_k,
                
                o_done => tb_done,
                
                o_mem_addr => exc_o_mem_addr,
                i_mem_data => tb_i_mem_data,
                o_mem_data => exc_o_mem_data,
                o_mem_we   => exc_o_mem_we,
                o_mem_en   => exc_o_mem_en
    );

    -- Clock generation
    tb_clk <= not tb_clk after CLOCK_PERIOD/2;

    -- Process related to the memory
    MEM : process (tb_clk)
    begin
        if tb_clk'event and tb_clk = '1' then
            if tb_o_mem_en = '1' then
                if tb_o_mem_we = '1' then
                    RAM(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
                    tb_i_mem_data <= tb_o_mem_data after 1 ns;
                else
                    tb_i_mem_data <= RAM(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
                end if;
            end if;
        end if;
    end process;
    
    memory_signal_swapper : process(memory_control, init_o_mem_addr, init_o_mem_data,
                                    init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                    exc_o_mem_data, exc_o_mem_en, exc_o_mem_we)
    begin
        -- This is necessary for the testbench to work: we swap the memory
        -- signals from the component to the testbench when needed.
    
        tb_o_mem_addr <= init_o_mem_addr;
        tb_o_mem_data <= init_o_mem_data;
        tb_o_mem_en   <= init_o_mem_en;
        tb_o_mem_we   <= init_o_mem_we;

        if memory_control = '1' then
            tb_o_mem_addr <= exc_o_mem_addr;
            tb_o_mem_data <= exc_o_mem_data;
            tb_o_mem_en   <= exc_o_mem_en;
            tb_o_mem_we   <= exc_o_mem_we;
        end if;
    end process;
    
    -- This process provides the correct scenario on the signal controlled by the TB
    create_scenario : process
    begin
        wait for 50 ns;

        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_k   <= (others=>'0');
        tb_rst <= '1';
        
        -- Wait some time for the component to reset...
        wait for 50 ns;
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
        
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock

        -- Configure the memory        
        for i in 0 to SCENARIO_LENGTH*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH, 10));
        
        tb_start <= '1';

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        wait for 5 ns;
        
        tb_start <= '0';
        
        wait;
        
    end process;

    -- Process without sensitivity list designed to test the actual component.
    test_routine : process
    begin

        wait until tb_rst = '1';
        wait for 25 ns;
        assert tb_done = '0' report "TEST FALLITO o_done !=0 during reset" severity failure;
        wait until tb_rst = '0';

        wait until falling_edge(tb_clk);
        assert tb_done = '0' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        
        wait until rising_edge(tb_start);

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;

        for i in 0 to SCENARIO_LENGTH*2-1 loop
            assert RAM(SCENARIO_ADDRESS+i) = std_logic_vector(to_unsigned(scenario_full(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;

        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        wait until falling_edge(tb_done);

        assert false report "Simulation Ended! TEST PASSATO (EXAMPLE)" severity failure;
    end process;

end architecture;
