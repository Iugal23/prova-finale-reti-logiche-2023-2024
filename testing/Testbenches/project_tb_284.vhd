-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_284 is
end project_tb_284;

architecture project_tb_arch_284 of project_tb_284 is
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

constant SCENARIO_LENGTH : integer := 604;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (45,0,5,0,0,0,28,0,191,0,0,0,0,0,245,0,105,0,5,0,4,0,118,0,57,0,28,0,200,0,110,0,155,0,47,0,81,0,22,0,95,0,131,0,29,0,0,0,17,0,0,0,171,0,116,0,227,0,209,0,56,0,52,0,148,0,61,0,0,0,0,0,61,0,207,0,22,0,204,0,53,0,173,0,83,0,152,0,215,0,82,0,0,0,10,0,0,0,224,0,0,0,125,0,0,0,144,0,87,0,147,0,0,0,110,0,228,0,43,0,245,0,208,0,35,0,51,0,139,0,0,0,254,0,161,0,174,0,127,0,23,0,105,0,177,0,179,0,147,0,52,0,13,0,121,0,34,0,100,0,88,0,26,0,104,0,216,0,254,0,7,0,0,0,0,0,0,0,82,0,81,0,0,0,32,0,0,0,0,0,95,0,36,0,9,0,72,0,212,0,152,0,83,0,191,0,114,0,130,0,54,0,58,0,0,0,110,0,64,0,111,0,116,0,38,0,32,0,0,0,76,0,134,0,221,0,0,0,108,0,178,0,255,0,0,0,37,0,18,0,0,0,0,0,0,0,119,0,128,0,48,0,70,0,122,0,0,0,7,0,191,0,216,0,166,0,0,0,114,0,135,0,147,0,0,0,59,0,254,0,196,0,222,0,106,0,0,0,85,0,204,0,105,0,0,0,237,0,6,0,58,0,0,0,87,0,0,0,87,0,89,0,107,0,62,0,153,0,0,0,0,0,247,0,99,0,0,0,89,0,0,0,107,0,127,0,169,0,128,0,136,0,27,0,172,0,166,0,172,0,220,0,244,0,77,0,81,0,21,0,185,0,175,0,194,0,210,0,125,0,0,0,188,0,0,0,0,0,169,0,195,0,54,0,18,0,0,0,156,0,0,0,111,0,193,0,217,0,0,0,0,0,58,0,100,0,35,0,0,0,211,0,52,0,157,0,0,0,28,0,172,0,126,0,121,0,0,0,176,0,0,0,96,0,6,0,34,0,155,0,243,0,39,0,27,0,0,0,0,0,71,0,150,0,74,0,0,0,44,0,0,0,193,0,16,0,114,0,0,0,0,0,208,0,224,0,141,0,48,0,89,0,252,0,0,0,155,0,37,0,218,0,207,0,48,0,5,0,152,0,163,0,35,0,0,0,29,0,44,0,171,0,0,0,250,0,124,0,0,0,208,0,242,0,45,0,118,0,114,0,0,0,66,0,66,0,98,0,0,0,221,0,0,0,0,0,0,0,0,0,119,0,17,0,65,0,0,0,250,0,2,0,87,0,102,0,114,0,254,0,212,0,12,0,77,0,116,0,23,0,0,0,168,0,128,0,186,0,0,0,152,0,1,0,252,0,222,0,30,0,212,0,199,0,0,0,63,0,182,0,139,0,184,0,0,0,229,0,228,0,3,0,0,0,0,0,155,0,26,0,243,0,14,0,224,0,202,0,21,0,244,0,48,0,0,0,124,0,199,0,0,0,49,0,213,0,0,0,214,0,191,0,168,0,125,0,170,0,105,0,151,0,0,0,217,0,0,0,69,0,97,0,126,0,183,0,96,0,199,0,125,0,100,0,0,0,240,0,149,0,70,0,0,0,12,0,221,0,61,0,164,0,247,0,246,0,20,0,171,0,0,0,5,0,150,0,59,0,123,0,33,0,72,0,43,0,51,0,104,0,103,0,57,0,134,0,157,0,87,0,105,0,0,0,67,0,56,0,45,0,148,0,242,0,157,0,82,0,0,0,198,0,101,0,180,0,15,0,76,0,240,0,34,0,150,0,0,0,105,0,117,0,106,0,151,0,179,0,47,0,100,0,31,0,0,0,236,0,0,0,207,0,81,0,0,0,212,0,219,0,72,0,0,0,0,0,0,0,61,0,100,0,19,0,80,0,162,0,9,0,12,0,103,0,130,0,88,0,0,0,0,0,154,0,126,0,0,0,206,0,19,0,123,0,123,0,28,0,18,0,0,0,29,0,238,0,16,0,12,0,0,0,180,0,0,0,17,0,82,0,27,0,58,0,124,0,69,0,0,0,186,0,250,0,0,0,0,0,133,0,223,0,24,0,0,0,141,0,60,0,245,0,53,0,0,0,91,0,161,0,213,0,15,0,178,0,112,0,54,0,0,0,2,0,242,0,89,0,0,0,65,0,60,0,18,0,18,0,57,0,161,0,15,0,79,0,130,0,99,0,0,0,0,0,0,0,78,0,153,0,157,0,215,0,157,0,185,0,0,0,139,0,148,0,226,0,0,0,182,0,124,0,144,0,0,0,72,0,131,0,0,0,0,0,0,0,133,0,134,0,185,0,117,0,15,0,212,0,37,0,134,0,9,0,184,0,0,0,246,0,41,0,179,0,72,0,52,0,0,0,0,0,0,0,231,0,0,0,0,0,0,0,123,0,25,0,9,0,200,0,239,0,221,0,160,0,208,0,0,0,176,0,37,0,0,0,182,0,100,0,164,0,24,0,55,0,225,0,206,0,57,0,223,0,28,0,59,0,195,0,14,0,180,0,7,0,3,0,40,0,0,0,0,0,213,0,0,0,176,0,0,0,8,0,0,0,195,0,0,0,227,0,254,0,207,0,129,0,249,0,53,0,0,0,19,0,50,0,0,0,0,0,106,0,0,0,7,0,139,0,133,0,139,0,82,0,79,0,53,0,246,0,0,0,94,0,9,0,14,0,66,0,0,0,202,0,142,0);
signal scenario_full  : scenario_type := (45,31,5,31,5,30,28,31,191,31,191,30,191,29,245,31,105,31,5,31,4,31,118,31,57,31,28,31,200,31,110,31,155,31,47,31,81,31,22,31,95,31,131,31,29,31,29,30,17,31,17,30,171,31,116,31,227,31,209,31,56,31,52,31,148,31,61,31,61,30,61,29,61,31,207,31,22,31,204,31,53,31,173,31,83,31,152,31,215,31,82,31,82,30,10,31,10,30,224,31,224,30,125,31,125,30,144,31,87,31,147,31,147,30,110,31,228,31,43,31,245,31,208,31,35,31,51,31,139,31,139,30,254,31,161,31,174,31,127,31,23,31,105,31,177,31,179,31,147,31,52,31,13,31,121,31,34,31,100,31,88,31,26,31,104,31,216,31,254,31,7,31,7,30,7,29,7,28,82,31,81,31,81,30,32,31,32,30,32,29,95,31,36,31,9,31,72,31,212,31,152,31,83,31,191,31,114,31,130,31,54,31,58,31,58,30,110,31,64,31,111,31,116,31,38,31,32,31,32,30,76,31,134,31,221,31,221,30,108,31,178,31,255,31,255,30,37,31,18,31,18,30,18,29,18,28,119,31,128,31,48,31,70,31,122,31,122,30,7,31,191,31,216,31,166,31,166,30,114,31,135,31,147,31,147,30,59,31,254,31,196,31,222,31,106,31,106,30,85,31,204,31,105,31,105,30,237,31,6,31,58,31,58,30,87,31,87,30,87,31,89,31,107,31,62,31,153,31,153,30,153,29,247,31,99,31,99,30,89,31,89,30,107,31,127,31,169,31,128,31,136,31,27,31,172,31,166,31,172,31,220,31,244,31,77,31,81,31,21,31,185,31,175,31,194,31,210,31,125,31,125,30,188,31,188,30,188,29,169,31,195,31,54,31,18,31,18,30,156,31,156,30,111,31,193,31,217,31,217,30,217,29,58,31,100,31,35,31,35,30,211,31,52,31,157,31,157,30,28,31,172,31,126,31,121,31,121,30,176,31,176,30,96,31,6,31,34,31,155,31,243,31,39,31,27,31,27,30,27,29,71,31,150,31,74,31,74,30,44,31,44,30,193,31,16,31,114,31,114,30,114,29,208,31,224,31,141,31,48,31,89,31,252,31,252,30,155,31,37,31,218,31,207,31,48,31,5,31,152,31,163,31,35,31,35,30,29,31,44,31,171,31,171,30,250,31,124,31,124,30,208,31,242,31,45,31,118,31,114,31,114,30,66,31,66,31,98,31,98,30,221,31,221,30,221,29,221,28,221,27,119,31,17,31,65,31,65,30,250,31,2,31,87,31,102,31,114,31,254,31,212,31,12,31,77,31,116,31,23,31,23,30,168,31,128,31,186,31,186,30,152,31,1,31,252,31,222,31,30,31,212,31,199,31,199,30,63,31,182,31,139,31,184,31,184,30,229,31,228,31,3,31,3,30,3,29,155,31,26,31,243,31,14,31,224,31,202,31,21,31,244,31,48,31,48,30,124,31,199,31,199,30,49,31,213,31,213,30,214,31,191,31,168,31,125,31,170,31,105,31,151,31,151,30,217,31,217,30,69,31,97,31,126,31,183,31,96,31,199,31,125,31,100,31,100,30,240,31,149,31,70,31,70,30,12,31,221,31,61,31,164,31,247,31,246,31,20,31,171,31,171,30,5,31,150,31,59,31,123,31,33,31,72,31,43,31,51,31,104,31,103,31,57,31,134,31,157,31,87,31,105,31,105,30,67,31,56,31,45,31,148,31,242,31,157,31,82,31,82,30,198,31,101,31,180,31,15,31,76,31,240,31,34,31,150,31,150,30,105,31,117,31,106,31,151,31,179,31,47,31,100,31,31,31,31,30,236,31,236,30,207,31,81,31,81,30,212,31,219,31,72,31,72,30,72,29,72,28,61,31,100,31,19,31,80,31,162,31,9,31,12,31,103,31,130,31,88,31,88,30,88,29,154,31,126,31,126,30,206,31,19,31,123,31,123,31,28,31,18,31,18,30,29,31,238,31,16,31,12,31,12,30,180,31,180,30,17,31,82,31,27,31,58,31,124,31,69,31,69,30,186,31,250,31,250,30,250,29,133,31,223,31,24,31,24,30,141,31,60,31,245,31,53,31,53,30,91,31,161,31,213,31,15,31,178,31,112,31,54,31,54,30,2,31,242,31,89,31,89,30,65,31,60,31,18,31,18,31,57,31,161,31,15,31,79,31,130,31,99,31,99,30,99,29,99,28,78,31,153,31,157,31,215,31,157,31,185,31,185,30,139,31,148,31,226,31,226,30,182,31,124,31,144,31,144,30,72,31,131,31,131,30,131,29,131,28,133,31,134,31,185,31,117,31,15,31,212,31,37,31,134,31,9,31,184,31,184,30,246,31,41,31,179,31,72,31,52,31,52,30,52,29,52,28,231,31,231,30,231,29,231,28,123,31,25,31,9,31,200,31,239,31,221,31,160,31,208,31,208,30,176,31,37,31,37,30,182,31,100,31,164,31,24,31,55,31,225,31,206,31,57,31,223,31,28,31,59,31,195,31,14,31,180,31,7,31,3,31,40,31,40,30,40,29,213,31,213,30,176,31,176,30,8,31,8,30,195,31,195,30,227,31,254,31,207,31,129,31,249,31,53,31,53,30,19,31,50,31,50,30,50,29,106,31,106,30,7,31,139,31,133,31,139,31,82,31,79,31,53,31,246,31,246,30,94,31,9,31,14,31,66,31,66,30,202,31,142,31);

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
