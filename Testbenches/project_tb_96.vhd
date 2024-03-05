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

constant SCENARIO_LENGTH : integer := 512;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (184,0,218,0,92,0,102,0,130,0,88,0,152,0,147,0,37,0,222,0,239,0,252,0,175,0,0,0,102,0,66,0,37,0,204,0,147,0,201,0,0,0,65,0,63,0,225,0,5,0,254,0,194,0,0,0,61,0,234,0,197,0,98,0,199,0,243,0,157,0,104,0,0,0,0,0,119,0,93,0,94,0,0,0,121,0,156,0,63,0,204,0,190,0,30,0,241,0,0,0,92,0,0,0,93,0,217,0,213,0,121,0,88,0,60,0,136,0,33,0,0,0,0,0,136,0,0,0,42,0,62,0,218,0,109,0,0,0,220,0,12,0,111,0,82,0,248,0,35,0,53,0,29,0,163,0,0,0,13,0,14,0,0,0,136,0,58,0,81,0,125,0,198,0,0,0,221,0,19,0,147,0,87,0,152,0,95,0,184,0,214,0,0,0,23,0,0,0,89,0,112,0,176,0,84,0,0,0,0,0,125,0,226,0,0,0,54,0,18,0,0,0,77,0,174,0,217,0,27,0,246,0,116,0,21,0,236,0,192,0,96,0,135,0,212,0,17,0,127,0,244,0,14,0,184,0,220,0,85,0,86,0,0,0,162,0,0,0,124,0,41,0,52,0,134,0,53,0,0,0,162,0,240,0,106,0,161,0,4,0,101,0,125,0,186,0,101,0,102,0,10,0,147,0,84,0,33,0,245,0,45,0,121,0,54,0,5,0,244,0,0,0,67,0,247,0,124,0,162,0,96,0,146,0,92,0,212,0,0,0,246,0,74,0,73,0,202,0,86,0,0,0,107,0,170,0,157,0,13,0,190,0,64,0,162,0,165,0,0,0,0,0,42,0,185,0,223,0,197,0,93,0,56,0,210,0,37,0,174,0,40,0,132,0,4,0,18,0,39,0,166,0,127,0,21,0,35,0,0,0,24,0,0,0,180,0,74,0,103,0,125,0,0,0,156,0,23,0,174,0,0,0,62,0,0,0,91,0,0,0,212,0,121,0,167,0,62,0,79,0,128,0,0,0,53,0,185,0,242,0,112,0,0,0,130,0,112,0,0,0,58,0,46,0,232,0,48,0,65,0,94,0,121,0,59,0,52,0,205,0,0,0,118,0,189,0,46,0,90,0,0,0,64,0,120,0,238,0,16,0,7,0,60,0,0,0,91,0,208,0,128,0,0,0,132,0,218,0,212,0,0,0,78,0,166,0,0,0,239,0,69,0,132,0,241,0,0,0,58,0,252,0,0,0,183,0,57,0,181,0,112,0,55,0,156,0,153,0,223,0,84,0,162,0,23,0,125,0,18,0,0,0,252,0,234,0,206,0,50,0,154,0,205,0,0,0,19,0,173,0,89,0,32,0,0,0,35,0,158,0,0,0,224,0,69,0,0,0,0,0,0,0,234,0,4,0,10,0,242,0,74,0,121,0,23,0,157,0,0,0,197,0,0,0,100,0,138,0,146,0,0,0,124,0,90,0,236,0,72,0,188,0,0,0,33,0,252,0,233,0,144,0,124,0,238,0,31,0,172,0,0,0,31,0,81,0,225,0,0,0,163,0,101,0,138,0,179,0,104,0,215,0,199,0,203,0,70,0,12,0,0,0,16,0,203,0,179,0,226,0,183,0,127,0,231,0,50,0,127,0,25,0,252,0,0,0,152,0,254,0,0,0,165,0,186,0,134,0,4,0,174,0,232,0,216,0,0,0,131,0,209,0,36,0,135,0,176,0,0,0,139,0,121,0,183,0,0,0,39,0,5,0,0,0,0,0,216,0,0,0,244,0,149,0,0,0,237,0,27,0,155,0,0,0,201,0,119,0,180,0,129,0,0,0,114,0,0,0,119,0,195,0,94,0,237,0,239,0,119,0,126,0,0,0,10,0,0,0,0,0,0,0,72,0,98,0,0,0,120,0,165,0,172,0,170,0,158,0,64,0,212,0,219,0,213,0,104,0,92,0,0,0,128,0,51,0,88,0,0,0,89,0,55,0,2,0,224,0,0,0,100,0,222,0,14,0,172,0,193,0,252,0,0,0,126,0,0,0,84,0,30,0,234,0,0,0,108,0,23,0,22,0,0,0,90,0,65,0,223,0,183,0,222,0,4,0,20,0,139,0,225,0,97,0,205,0,240,0,16,0,89,0,0,0,111,0,202,0,90,0,0,0,0,0,239,0,251,0,97,0,1,0,123,0,115,0,195,0,31,0,78,0,63,0,0,0,204,0,121,0,133,0,176,0,89,0,229,0,0,0,205,0,0,0,24,0,14,0,55,0,74,0,49,0,191,0,0,0,0,0,8,0,78,0);
signal scenario_full  : scenario_type := (184,31,218,31,92,31,102,31,130,31,88,31,152,31,147,31,37,31,222,31,239,31,252,31,175,31,175,30,102,31,66,31,37,31,204,31,147,31,201,31,201,30,65,31,63,31,225,31,5,31,254,31,194,31,194,30,61,31,234,31,197,31,98,31,199,31,243,31,157,31,104,31,104,30,104,29,119,31,93,31,94,31,94,30,121,31,156,31,63,31,204,31,190,31,30,31,241,31,241,30,92,31,92,30,93,31,217,31,213,31,121,31,88,31,60,31,136,31,33,31,33,30,33,29,136,31,136,30,42,31,62,31,218,31,109,31,109,30,220,31,12,31,111,31,82,31,248,31,35,31,53,31,29,31,163,31,163,30,13,31,14,31,14,30,136,31,58,31,81,31,125,31,198,31,198,30,221,31,19,31,147,31,87,31,152,31,95,31,184,31,214,31,214,30,23,31,23,30,89,31,112,31,176,31,84,31,84,30,84,29,125,31,226,31,226,30,54,31,18,31,18,30,77,31,174,31,217,31,27,31,246,31,116,31,21,31,236,31,192,31,96,31,135,31,212,31,17,31,127,31,244,31,14,31,184,31,220,31,85,31,86,31,86,30,162,31,162,30,124,31,41,31,52,31,134,31,53,31,53,30,162,31,240,31,106,31,161,31,4,31,101,31,125,31,186,31,101,31,102,31,10,31,147,31,84,31,33,31,245,31,45,31,121,31,54,31,5,31,244,31,244,30,67,31,247,31,124,31,162,31,96,31,146,31,92,31,212,31,212,30,246,31,74,31,73,31,202,31,86,31,86,30,107,31,170,31,157,31,13,31,190,31,64,31,162,31,165,31,165,30,165,29,42,31,185,31,223,31,197,31,93,31,56,31,210,31,37,31,174,31,40,31,132,31,4,31,18,31,39,31,166,31,127,31,21,31,35,31,35,30,24,31,24,30,180,31,74,31,103,31,125,31,125,30,156,31,23,31,174,31,174,30,62,31,62,30,91,31,91,30,212,31,121,31,167,31,62,31,79,31,128,31,128,30,53,31,185,31,242,31,112,31,112,30,130,31,112,31,112,30,58,31,46,31,232,31,48,31,65,31,94,31,121,31,59,31,52,31,205,31,205,30,118,31,189,31,46,31,90,31,90,30,64,31,120,31,238,31,16,31,7,31,60,31,60,30,91,31,208,31,128,31,128,30,132,31,218,31,212,31,212,30,78,31,166,31,166,30,239,31,69,31,132,31,241,31,241,30,58,31,252,31,252,30,183,31,57,31,181,31,112,31,55,31,156,31,153,31,223,31,84,31,162,31,23,31,125,31,18,31,18,30,252,31,234,31,206,31,50,31,154,31,205,31,205,30,19,31,173,31,89,31,32,31,32,30,35,31,158,31,158,30,224,31,69,31,69,30,69,29,69,28,234,31,4,31,10,31,242,31,74,31,121,31,23,31,157,31,157,30,197,31,197,30,100,31,138,31,146,31,146,30,124,31,90,31,236,31,72,31,188,31,188,30,33,31,252,31,233,31,144,31,124,31,238,31,31,31,172,31,172,30,31,31,81,31,225,31,225,30,163,31,101,31,138,31,179,31,104,31,215,31,199,31,203,31,70,31,12,31,12,30,16,31,203,31,179,31,226,31,183,31,127,31,231,31,50,31,127,31,25,31,252,31,252,30,152,31,254,31,254,30,165,31,186,31,134,31,4,31,174,31,232,31,216,31,216,30,131,31,209,31,36,31,135,31,176,31,176,30,139,31,121,31,183,31,183,30,39,31,5,31,5,30,5,29,216,31,216,30,244,31,149,31,149,30,237,31,27,31,155,31,155,30,201,31,119,31,180,31,129,31,129,30,114,31,114,30,119,31,195,31,94,31,237,31,239,31,119,31,126,31,126,30,10,31,10,30,10,29,10,28,72,31,98,31,98,30,120,31,165,31,172,31,170,31,158,31,64,31,212,31,219,31,213,31,104,31,92,31,92,30,128,31,51,31,88,31,88,30,89,31,55,31,2,31,224,31,224,30,100,31,222,31,14,31,172,31,193,31,252,31,252,30,126,31,126,30,84,31,30,31,234,31,234,30,108,31,23,31,22,31,22,30,90,31,65,31,223,31,183,31,222,31,4,31,20,31,139,31,225,31,97,31,205,31,240,31,16,31,89,31,89,30,111,31,202,31,90,31,90,30,90,29,239,31,251,31,97,31,1,31,123,31,115,31,195,31,31,31,78,31,63,31,63,30,204,31,121,31,133,31,176,31,89,31,229,31,229,30,205,31,205,30,24,31,14,31,55,31,74,31,49,31,191,31,191,30,191,29,8,31,78,31);

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
