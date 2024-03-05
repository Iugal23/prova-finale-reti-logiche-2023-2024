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

constant SCENARIO_LENGTH : integer := 274;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (142,0,64,0,58,0,0,0,0,0,23,0,94,0,104,0,140,0,83,0,0,0,0,0,135,0,0,0,228,0,87,0,145,0,22,0,62,0,229,0,0,0,53,0,23,0,14,0,140,0,172,0,178,0,0,0,27,0,115,0,50,0,0,0,0,0,159,0,35,0,0,0,201,0,201,0,0,0,0,0,0,0,123,0,123,0,20,0,127,0,0,0,0,0,111,0,161,0,80,0,16,0,0,0,42,0,0,0,129,0,57,0,227,0,149,0,0,0,94,0,89,0,148,0,205,0,55,0,0,0,0,0,68,0,55,0,127,0,76,0,13,0,208,0,0,0,190,0,91,0,37,0,0,0,101,0,245,0,23,0,0,0,134,0,76,0,207,0,229,0,0,0,77,0,74,0,183,0,242,0,0,0,231,0,0,0,16,0,0,0,41,0,231,0,118,0,253,0,221,0,193,0,0,0,229,0,0,0,61,0,229,0,101,0,0,0,63,0,32,0,147,0,99,0,0,0,0,0,0,0,247,0,40,0,184,0,228,0,44,0,0,0,108,0,67,0,0,0,0,0,130,0,90,0,0,0,109,0,165,0,59,0,221,0,0,0,0,0,25,0,65,0,35,0,98,0,254,0,130,0,34,0,86,0,191,0,77,0,102,0,181,0,0,0,0,0,76,0,0,0,16,0,2,0,173,0,24,0,175,0,0,0,21,0,34,0,11,0,0,0,237,0,245,0,140,0,198,0,46,0,148,0,214,0,118,0,207,0,191,0,231,0,125,0,0,0,115,0,151,0,158,0,133,0,19,0,160,0,221,0,133,0,143,0,218,0,70,0,31,0,143,0,154,0,226,0,182,0,134,0,194,0,223,0,69,0,152,0,204,0,65,0,237,0,249,0,84,0,69,0,102,0,24,0,223,0,221,0,0,0,53,0,2,0,200,0,91,0,0,0,160,0,0,0,250,0,237,0,13,0,46,0,208,0,0,0,0,0,12,0,3,0,0,0,252,0,241,0,97,0,43,0,138,0,149,0,0,0,147,0,119,0,0,0,8,0,118,0,155,0,103,0,230,0,107,0,31,0,245,0,232,0,118,0,184,0,185,0,79,0,104,0,183,0,65,0,0,0,0,0,18,0,0,0,182,0,99,0,205,0,254,0,0,0,0,0,228,0,0,0,0,0,192,0,0,0,123,0,0,0,124,0,7,0,41,0,109,0,41,0,0,0,0,0,106,0,190,0);
signal scenario_full  : scenario_type := (142,31,64,31,58,31,58,30,58,29,23,31,94,31,104,31,140,31,83,31,83,30,83,29,135,31,135,30,228,31,87,31,145,31,22,31,62,31,229,31,229,30,53,31,23,31,14,31,140,31,172,31,178,31,178,30,27,31,115,31,50,31,50,30,50,29,159,31,35,31,35,30,201,31,201,31,201,30,201,29,201,28,123,31,123,31,20,31,127,31,127,30,127,29,111,31,161,31,80,31,16,31,16,30,42,31,42,30,129,31,57,31,227,31,149,31,149,30,94,31,89,31,148,31,205,31,55,31,55,30,55,29,68,31,55,31,127,31,76,31,13,31,208,31,208,30,190,31,91,31,37,31,37,30,101,31,245,31,23,31,23,30,134,31,76,31,207,31,229,31,229,30,77,31,74,31,183,31,242,31,242,30,231,31,231,30,16,31,16,30,41,31,231,31,118,31,253,31,221,31,193,31,193,30,229,31,229,30,61,31,229,31,101,31,101,30,63,31,32,31,147,31,99,31,99,30,99,29,99,28,247,31,40,31,184,31,228,31,44,31,44,30,108,31,67,31,67,30,67,29,130,31,90,31,90,30,109,31,165,31,59,31,221,31,221,30,221,29,25,31,65,31,35,31,98,31,254,31,130,31,34,31,86,31,191,31,77,31,102,31,181,31,181,30,181,29,76,31,76,30,16,31,2,31,173,31,24,31,175,31,175,30,21,31,34,31,11,31,11,30,237,31,245,31,140,31,198,31,46,31,148,31,214,31,118,31,207,31,191,31,231,31,125,31,125,30,115,31,151,31,158,31,133,31,19,31,160,31,221,31,133,31,143,31,218,31,70,31,31,31,143,31,154,31,226,31,182,31,134,31,194,31,223,31,69,31,152,31,204,31,65,31,237,31,249,31,84,31,69,31,102,31,24,31,223,31,221,31,221,30,53,31,2,31,200,31,91,31,91,30,160,31,160,30,250,31,237,31,13,31,46,31,208,31,208,30,208,29,12,31,3,31,3,30,252,31,241,31,97,31,43,31,138,31,149,31,149,30,147,31,119,31,119,30,8,31,118,31,155,31,103,31,230,31,107,31,31,31,245,31,232,31,118,31,184,31,185,31,79,31,104,31,183,31,65,31,65,30,65,29,18,31,18,30,182,31,99,31,205,31,254,31,254,30,254,29,228,31,228,30,228,29,192,31,192,30,123,31,123,30,124,31,7,31,41,31,109,31,41,31,41,30,41,29,106,31,190,31);

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
