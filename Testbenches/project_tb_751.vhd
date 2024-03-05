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

constant SCENARIO_LENGTH : integer := 275;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (117,0,9,0,97,0,95,0,133,0,4,0,69,0,0,0,242,0,151,0,0,0,0,0,76,0,184,0,95,0,240,0,172,0,2,0,0,0,0,0,0,0,45,0,226,0,149,0,161,0,9,0,52,0,0,0,238,0,0,0,163,0,98,0,0,0,13,0,15,0,0,0,27,0,141,0,196,0,131,0,7,0,164,0,58,0,232,0,0,0,221,0,94,0,123,0,37,0,144,0,0,0,115,0,72,0,5,0,236,0,241,0,21,0,34,0,211,0,164,0,185,0,88,0,211,0,211,0,231,0,203,0,86,0,0,0,234,0,32,0,123,0,0,0,68,0,250,0,176,0,176,0,228,0,158,0,255,0,99,0,249,0,250,0,78,0,253,0,197,0,160,0,17,0,134,0,0,0,83,0,203,0,248,0,0,0,227,0,236,0,46,0,0,0,155,0,0,0,102,0,45,0,0,0,2,0,67,0,141,0,194,0,119,0,3,0,77,0,0,0,73,0,42,0,64,0,14,0,215,0,52,0,20,0,170,0,85,0,102,0,97,0,48,0,182,0,254,0,161,0,110,0,214,0,194,0,185,0,130,0,51,0,220,0,0,0,0,0,151,0,36,0,93,0,226,0,66,0,242,0,0,0,0,0,214,0,183,0,234,0,114,0,17,0,184,0,52,0,190,0,19,0,87,0,37,0,0,0,191,0,141,0,95,0,170,0,229,0,0,0,164,0,0,0,0,0,0,0,123,0,36,0,115,0,56,0,100,0,212,0,120,0,204,0,0,0,255,0,93,0,0,0,32,0,251,0,0,0,157,0,115,0,183,0,204,0,0,0,19,0,128,0,183,0,100,0,77,0,170,0,222,0,33,0,177,0,166,0,248,0,193,0,230,0,98,0,58,0,219,0,234,0,153,0,0,0,207,0,69,0,124,0,135,0,212,0,0,0,42,0,0,0,113,0,144,0,132,0,33,0,1,0,218,0,77,0,32,0,22,0,199,0,52,0,215,0,87,0,120,0,9,0,241,0,131,0,0,0,252,0,15,0,253,0,75,0,94,0,21,0,136,0,229,0,45,0,0,0,175,0,8,0,31,0,251,0,215,0,174,0,0,0,0,0,64,0,40,0,91,0,0,0,158,0,33,0,106,0,0,0,80,0,92,0,29,0,222,0,212,0,0,0,102,0,225,0,188,0,0,0,25,0,175,0,0,0,84,0,13,0,118,0,126,0,87,0,155,0,88,0);
signal scenario_full  : scenario_type := (117,31,9,31,97,31,95,31,133,31,4,31,69,31,69,30,242,31,151,31,151,30,151,29,76,31,184,31,95,31,240,31,172,31,2,31,2,30,2,29,2,28,45,31,226,31,149,31,161,31,9,31,52,31,52,30,238,31,238,30,163,31,98,31,98,30,13,31,15,31,15,30,27,31,141,31,196,31,131,31,7,31,164,31,58,31,232,31,232,30,221,31,94,31,123,31,37,31,144,31,144,30,115,31,72,31,5,31,236,31,241,31,21,31,34,31,211,31,164,31,185,31,88,31,211,31,211,31,231,31,203,31,86,31,86,30,234,31,32,31,123,31,123,30,68,31,250,31,176,31,176,31,228,31,158,31,255,31,99,31,249,31,250,31,78,31,253,31,197,31,160,31,17,31,134,31,134,30,83,31,203,31,248,31,248,30,227,31,236,31,46,31,46,30,155,31,155,30,102,31,45,31,45,30,2,31,67,31,141,31,194,31,119,31,3,31,77,31,77,30,73,31,42,31,64,31,14,31,215,31,52,31,20,31,170,31,85,31,102,31,97,31,48,31,182,31,254,31,161,31,110,31,214,31,194,31,185,31,130,31,51,31,220,31,220,30,220,29,151,31,36,31,93,31,226,31,66,31,242,31,242,30,242,29,214,31,183,31,234,31,114,31,17,31,184,31,52,31,190,31,19,31,87,31,37,31,37,30,191,31,141,31,95,31,170,31,229,31,229,30,164,31,164,30,164,29,164,28,123,31,36,31,115,31,56,31,100,31,212,31,120,31,204,31,204,30,255,31,93,31,93,30,32,31,251,31,251,30,157,31,115,31,183,31,204,31,204,30,19,31,128,31,183,31,100,31,77,31,170,31,222,31,33,31,177,31,166,31,248,31,193,31,230,31,98,31,58,31,219,31,234,31,153,31,153,30,207,31,69,31,124,31,135,31,212,31,212,30,42,31,42,30,113,31,144,31,132,31,33,31,1,31,218,31,77,31,32,31,22,31,199,31,52,31,215,31,87,31,120,31,9,31,241,31,131,31,131,30,252,31,15,31,253,31,75,31,94,31,21,31,136,31,229,31,45,31,45,30,175,31,8,31,31,31,251,31,215,31,174,31,174,30,174,29,64,31,40,31,91,31,91,30,158,31,33,31,106,31,106,30,80,31,92,31,29,31,222,31,212,31,212,30,102,31,225,31,188,31,188,30,25,31,175,31,175,30,84,31,13,31,118,31,126,31,87,31,155,31,88,31);

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
