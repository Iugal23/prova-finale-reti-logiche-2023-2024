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

constant SCENARIO_LENGTH : integer := 518;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (147,0,244,0,32,0,148,0,197,0,0,0,58,0,222,0,208,0,37,0,106,0,0,0,0,0,31,0,136,0,0,0,193,0,0,0,205,0,148,0,68,0,0,0,0,0,0,0,215,0,235,0,0,0,144,0,1,0,173,0,26,0,0,0,226,0,58,0,241,0,44,0,181,0,201,0,4,0,114,0,5,0,0,0,31,0,0,0,0,0,219,0,0,0,175,0,42,0,95,0,16,0,252,0,138,0,96,0,108,0,248,0,0,0,0,0,0,0,129,0,87,0,9,0,236,0,0,0,35,0,0,0,178,0,16,0,85,0,0,0,203,0,28,0,185,0,8,0,169,0,222,0,0,0,56,0,108,0,188,0,0,0,98,0,245,0,176,0,210,0,132,0,146,0,85,0,90,0,186,0,0,0,36,0,248,0,0,0,41,0,247,0,71,0,208,0,131,0,100,0,8,0,109,0,60,0,149,0,163,0,0,0,63,0,100,0,59,0,0,0,14,0,0,0,158,0,160,0,55,0,49,0,226,0,220,0,232,0,14,0,0,0,0,0,0,0,0,0,23,0,120,0,0,0,7,0,218,0,0,0,139,0,11,0,251,0,229,0,212,0,7,0,175,0,94,0,136,0,135,0,117,0,25,0,22,0,162,0,25,0,147,0,186,0,55,0,243,0,23,0,76,0,2,0,0,0,162,0,77,0,151,0,23,0,0,0,0,0,97,0,148,0,0,0,187,0,243,0,192,0,121,0,145,0,0,0,108,0,107,0,0,0,229,0,87,0,0,0,227,0,218,0,117,0,0,0,1,0,241,0,138,0,0,0,127,0,185,0,112,0,210,0,0,0,95,0,171,0,119,0,227,0,100,0,148,0,0,0,0,0,0,0,199,0,74,0,0,0,4,0,102,0,213,0,0,0,172,0,166,0,141,0,19,0,89,0,160,0,123,0,13,0,244,0,0,0,42,0,81,0,0,0,12,0,0,0,180,0,210,0,0,0,148,0,0,0,214,0,0,0,102,0,239,0,115,0,254,0,0,0,205,0,215,0,196,0,199,0,157,0,235,0,231,0,109,0,9,0,11,0,58,0,88,0,224,0,249,0,141,0,14,0,118,0,12,0,229,0,218,0,77,0,126,0,35,0,0,0,0,0,35,0,175,0,0,0,21,0,0,0,249,0,146,0,212,0,6,0,134,0,20,0,138,0,115,0,23,0,161,0,14,0,169,0,123,0,0,0,68,0,124,0,0,0,163,0,0,0,130,0,14,0,32,0,222,0,196,0,202,0,95,0,218,0,210,0,0,0,0,0,81,0,47,0,63,0,0,0,201,0,71,0,0,0,0,0,134,0,58,0,53,0,0,0,245,0,43,0,220,0,226,0,0,0,209,0,142,0,89,0,87,0,40,0,120,0,205,0,0,0,76,0,0,0,59,0,187,0,138,0,28,0,61,0,44,0,12,0,25,0,23,0,21,0,241,0,64,0,98,0,212,0,68,0,0,0,209,0,6,0,53,0,79,0,211,0,0,0,81,0,39,0,36,0,45,0,195,0,0,0,0,0,185,0,229,0,0,0,127,0,88,0,0,0,105,0,241,0,63,0,121,0,248,0,95,0,0,0,81,0,32,0,126,0,0,0,111,0,117,0,157,0,0,0,189,0,0,0,2,0,0,0,12,0,79,0,83,0,224,0,0,0,0,0,17,0,130,0,0,0,78,0,155,0,148,0,0,0,11,0,103,0,2,0,0,0,195,0,186,0,5,0,0,0,196,0,0,0,105,0,0,0,11,0,145,0,0,0,84,0,0,0,193,0,162,0,100,0,149,0,71,0,93,0,0,0,183,0,0,0,79,0,146,0,0,0,220,0,21,0,174,0,73,0,0,0,193,0,223,0,77,0,35,0,130,0,0,0,79,0,89,0,0,0,0,0,56,0,49,0,97,0,44,0,165,0,114,0,124,0,97,0,21,0,0,0,170,0,0,0,75,0,208,0,0,0,255,0,174,0,136,0,231,0,0,0,195,0,22,0,148,0,243,0,11,0,0,0,119,0,236,0,13,0,235,0,0,0,16,0,57,0,216,0,238,0,175,0,237,0,0,0,226,0,51,0,51,0,62,0,0,0,107,0,0,0,176,0,151,0,62,0,219,0,0,0,110,0,203,0,103,0,0,0,107,0,253,0,116,0,199,0,0,0,160,0,249,0,6,0,0,0,0,0,0,0,0,0,234,0,16,0,0,0,155,0,0,0,162,0,0,0,159,0,53,0,222,0,23,0,189,0,239,0,0,0,0,0,46,0,148,0,0,0,66,0,30,0,216,0,232,0,128,0,132,0);
signal scenario_full  : scenario_type := (147,31,244,31,32,31,148,31,197,31,197,30,58,31,222,31,208,31,37,31,106,31,106,30,106,29,31,31,136,31,136,30,193,31,193,30,205,31,148,31,68,31,68,30,68,29,68,28,215,31,235,31,235,30,144,31,1,31,173,31,26,31,26,30,226,31,58,31,241,31,44,31,181,31,201,31,4,31,114,31,5,31,5,30,31,31,31,30,31,29,219,31,219,30,175,31,42,31,95,31,16,31,252,31,138,31,96,31,108,31,248,31,248,30,248,29,248,28,129,31,87,31,9,31,236,31,236,30,35,31,35,30,178,31,16,31,85,31,85,30,203,31,28,31,185,31,8,31,169,31,222,31,222,30,56,31,108,31,188,31,188,30,98,31,245,31,176,31,210,31,132,31,146,31,85,31,90,31,186,31,186,30,36,31,248,31,248,30,41,31,247,31,71,31,208,31,131,31,100,31,8,31,109,31,60,31,149,31,163,31,163,30,63,31,100,31,59,31,59,30,14,31,14,30,158,31,160,31,55,31,49,31,226,31,220,31,232,31,14,31,14,30,14,29,14,28,14,27,23,31,120,31,120,30,7,31,218,31,218,30,139,31,11,31,251,31,229,31,212,31,7,31,175,31,94,31,136,31,135,31,117,31,25,31,22,31,162,31,25,31,147,31,186,31,55,31,243,31,23,31,76,31,2,31,2,30,162,31,77,31,151,31,23,31,23,30,23,29,97,31,148,31,148,30,187,31,243,31,192,31,121,31,145,31,145,30,108,31,107,31,107,30,229,31,87,31,87,30,227,31,218,31,117,31,117,30,1,31,241,31,138,31,138,30,127,31,185,31,112,31,210,31,210,30,95,31,171,31,119,31,227,31,100,31,148,31,148,30,148,29,148,28,199,31,74,31,74,30,4,31,102,31,213,31,213,30,172,31,166,31,141,31,19,31,89,31,160,31,123,31,13,31,244,31,244,30,42,31,81,31,81,30,12,31,12,30,180,31,210,31,210,30,148,31,148,30,214,31,214,30,102,31,239,31,115,31,254,31,254,30,205,31,215,31,196,31,199,31,157,31,235,31,231,31,109,31,9,31,11,31,58,31,88,31,224,31,249,31,141,31,14,31,118,31,12,31,229,31,218,31,77,31,126,31,35,31,35,30,35,29,35,31,175,31,175,30,21,31,21,30,249,31,146,31,212,31,6,31,134,31,20,31,138,31,115,31,23,31,161,31,14,31,169,31,123,31,123,30,68,31,124,31,124,30,163,31,163,30,130,31,14,31,32,31,222,31,196,31,202,31,95,31,218,31,210,31,210,30,210,29,81,31,47,31,63,31,63,30,201,31,71,31,71,30,71,29,134,31,58,31,53,31,53,30,245,31,43,31,220,31,226,31,226,30,209,31,142,31,89,31,87,31,40,31,120,31,205,31,205,30,76,31,76,30,59,31,187,31,138,31,28,31,61,31,44,31,12,31,25,31,23,31,21,31,241,31,64,31,98,31,212,31,68,31,68,30,209,31,6,31,53,31,79,31,211,31,211,30,81,31,39,31,36,31,45,31,195,31,195,30,195,29,185,31,229,31,229,30,127,31,88,31,88,30,105,31,241,31,63,31,121,31,248,31,95,31,95,30,81,31,32,31,126,31,126,30,111,31,117,31,157,31,157,30,189,31,189,30,2,31,2,30,12,31,79,31,83,31,224,31,224,30,224,29,17,31,130,31,130,30,78,31,155,31,148,31,148,30,11,31,103,31,2,31,2,30,195,31,186,31,5,31,5,30,196,31,196,30,105,31,105,30,11,31,145,31,145,30,84,31,84,30,193,31,162,31,100,31,149,31,71,31,93,31,93,30,183,31,183,30,79,31,146,31,146,30,220,31,21,31,174,31,73,31,73,30,193,31,223,31,77,31,35,31,130,31,130,30,79,31,89,31,89,30,89,29,56,31,49,31,97,31,44,31,165,31,114,31,124,31,97,31,21,31,21,30,170,31,170,30,75,31,208,31,208,30,255,31,174,31,136,31,231,31,231,30,195,31,22,31,148,31,243,31,11,31,11,30,119,31,236,31,13,31,235,31,235,30,16,31,57,31,216,31,238,31,175,31,237,31,237,30,226,31,51,31,51,31,62,31,62,30,107,31,107,30,176,31,151,31,62,31,219,31,219,30,110,31,203,31,103,31,103,30,107,31,253,31,116,31,199,31,199,30,160,31,249,31,6,31,6,30,6,29,6,28,6,27,234,31,16,31,16,30,155,31,155,30,162,31,162,30,159,31,53,31,222,31,23,31,189,31,239,31,239,30,239,29,46,31,148,31,148,30,66,31,30,31,216,31,232,31,128,31,132,31);

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
