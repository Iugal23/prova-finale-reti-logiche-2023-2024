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

constant SCENARIO_LENGTH : integer := 376;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (188,0,91,0,0,0,114,0,203,0,157,0,96,0,101,0,221,0,219,0,242,0,189,0,124,0,41,0,0,0,242,0,0,0,169,0,237,0,121,0,26,0,153,0,0,0,211,0,130,0,184,0,162,0,0,0,0,0,240,0,0,0,89,0,4,0,175,0,171,0,189,0,217,0,137,0,240,0,128,0,159,0,210,0,148,0,212,0,98,0,130,0,139,0,0,0,68,0,85,0,146,0,229,0,134,0,67,0,97,0,234,0,0,0,53,0,128,0,47,0,31,0,4,0,94,0,95,0,163,0,92,0,30,0,97,0,143,0,41,0,210,0,164,0,134,0,215,0,233,0,107,0,0,0,44,0,152,0,229,0,0,0,98,0,0,0,48,0,147,0,17,0,35,0,218,0,167,0,203,0,0,0,99,0,127,0,37,0,250,0,30,0,184,0,0,0,87,0,142,0,78,0,79,0,56,0,215,0,136,0,213,0,0,0,160,0,231,0,136,0,0,0,143,0,69,0,13,0,228,0,0,0,148,0,0,0,59,0,166,0,72,0,173,0,240,0,2,0,210,0,91,0,244,0,96,0,235,0,0,0,219,0,141,0,13,0,129,0,20,0,0,0,96,0,0,0,167,0,37,0,5,0,114,0,28,0,66,0,226,0,154,0,0,0,143,0,0,0,123,0,117,0,112,0,0,0,29,0,202,0,175,0,18,0,201,0,0,0,183,0,15,0,255,0,173,0,172,0,68,0,38,0,145,0,114,0,0,0,82,0,109,0,152,0,225,0,25,0,157,0,185,0,0,0,116,0,251,0,254,0,51,0,225,0,18,0,139,0,144,0,153,0,160,0,233,0,122,0,235,0,0,0,25,0,209,0,0,0,16,0,252,0,32,0,0,0,15,0,70,0,0,0,193,0,161,0,240,0,13,0,0,0,98,0,161,0,0,0,239,0,67,0,14,0,0,0,70,0,215,0,13,0,238,0,127,0,105,0,41,0,0,0,0,0,162,0,86,0,0,0,45,0,163,0,118,0,58,0,115,0,0,0,158,0,205,0,56,0,2,0,0,0,0,0,105,0,9,0,84,0,194,0,58,0,242,0,35,0,8,0,156,0,183,0,69,0,175,0,0,0,0,0,0,0,57,0,159,0,0,0,106,0,238,0,108,0,110,0,75,0,0,0,73,0,78,0,4,0,219,0,63,0,0,0,1,0,48,0,211,0,7,0,232,0,12,0,0,0,0,0,21,0,93,0,215,0,85,0,0,0,65,0,134,0,0,0,0,0,8,0,11,0,25,0,16,0,175,0,0,0,0,0,81,0,75,0,95,0,98,0,227,0,0,0,66,0,0,0,0,0,0,0,139,0,93,0,0,0,60,0,199,0,0,0,224,0,125,0,8,0,189,0,148,0,14,0,43,0,0,0,232,0,200,0,27,0,163,0,31,0,147,0,163,0,87,0,55,0,150,0,216,0,161,0,191,0,168,0,64,0,80,0,33,0,27,0,133,0,169,0,160,0,56,0,71,0,19,0,32,0,0,0,156,0,214,0,45,0,230,0,216,0,76,0,82,0,247,0,49,0,145,0,190,0,144,0,137,0,0,0,24,0,66,0,191,0,0,0,36,0,156,0,33,0,215,0,53,0,0,0,5,0,188,0,97,0,203,0,214,0,182,0,107,0,0,0,0,0,0,0,28,0);
signal scenario_full  : scenario_type := (188,31,91,31,91,30,114,31,203,31,157,31,96,31,101,31,221,31,219,31,242,31,189,31,124,31,41,31,41,30,242,31,242,30,169,31,237,31,121,31,26,31,153,31,153,30,211,31,130,31,184,31,162,31,162,30,162,29,240,31,240,30,89,31,4,31,175,31,171,31,189,31,217,31,137,31,240,31,128,31,159,31,210,31,148,31,212,31,98,31,130,31,139,31,139,30,68,31,85,31,146,31,229,31,134,31,67,31,97,31,234,31,234,30,53,31,128,31,47,31,31,31,4,31,94,31,95,31,163,31,92,31,30,31,97,31,143,31,41,31,210,31,164,31,134,31,215,31,233,31,107,31,107,30,44,31,152,31,229,31,229,30,98,31,98,30,48,31,147,31,17,31,35,31,218,31,167,31,203,31,203,30,99,31,127,31,37,31,250,31,30,31,184,31,184,30,87,31,142,31,78,31,79,31,56,31,215,31,136,31,213,31,213,30,160,31,231,31,136,31,136,30,143,31,69,31,13,31,228,31,228,30,148,31,148,30,59,31,166,31,72,31,173,31,240,31,2,31,210,31,91,31,244,31,96,31,235,31,235,30,219,31,141,31,13,31,129,31,20,31,20,30,96,31,96,30,167,31,37,31,5,31,114,31,28,31,66,31,226,31,154,31,154,30,143,31,143,30,123,31,117,31,112,31,112,30,29,31,202,31,175,31,18,31,201,31,201,30,183,31,15,31,255,31,173,31,172,31,68,31,38,31,145,31,114,31,114,30,82,31,109,31,152,31,225,31,25,31,157,31,185,31,185,30,116,31,251,31,254,31,51,31,225,31,18,31,139,31,144,31,153,31,160,31,233,31,122,31,235,31,235,30,25,31,209,31,209,30,16,31,252,31,32,31,32,30,15,31,70,31,70,30,193,31,161,31,240,31,13,31,13,30,98,31,161,31,161,30,239,31,67,31,14,31,14,30,70,31,215,31,13,31,238,31,127,31,105,31,41,31,41,30,41,29,162,31,86,31,86,30,45,31,163,31,118,31,58,31,115,31,115,30,158,31,205,31,56,31,2,31,2,30,2,29,105,31,9,31,84,31,194,31,58,31,242,31,35,31,8,31,156,31,183,31,69,31,175,31,175,30,175,29,175,28,57,31,159,31,159,30,106,31,238,31,108,31,110,31,75,31,75,30,73,31,78,31,4,31,219,31,63,31,63,30,1,31,48,31,211,31,7,31,232,31,12,31,12,30,12,29,21,31,93,31,215,31,85,31,85,30,65,31,134,31,134,30,134,29,8,31,11,31,25,31,16,31,175,31,175,30,175,29,81,31,75,31,95,31,98,31,227,31,227,30,66,31,66,30,66,29,66,28,139,31,93,31,93,30,60,31,199,31,199,30,224,31,125,31,8,31,189,31,148,31,14,31,43,31,43,30,232,31,200,31,27,31,163,31,31,31,147,31,163,31,87,31,55,31,150,31,216,31,161,31,191,31,168,31,64,31,80,31,33,31,27,31,133,31,169,31,160,31,56,31,71,31,19,31,32,31,32,30,156,31,214,31,45,31,230,31,216,31,76,31,82,31,247,31,49,31,145,31,190,31,144,31,137,31,137,30,24,31,66,31,191,31,191,30,36,31,156,31,33,31,215,31,53,31,53,30,5,31,188,31,97,31,203,31,214,31,182,31,107,31,107,30,107,29,107,28,28,31);

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
