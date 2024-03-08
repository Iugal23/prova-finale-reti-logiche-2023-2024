-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_145 is
end project_tb_145;

architecture project_tb_arch_145 of project_tb_145 is
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

constant SCENARIO_LENGTH : integer := 351;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,0,0,33,0,21,0,0,0,134,0,118,0,65,0,223,0,0,0,138,0,0,0,80,0,0,0,193,0,180,0,0,0,56,0,181,0,0,0,239,0,9,0,252,0,142,0,34,0,26,0,230,0,221,0,169,0,162,0,207,0,31,0,0,0,0,0,0,0,0,0,255,0,0,0,217,0,0,0,182,0,209,0,217,0,178,0,63,0,103,0,0,0,18,0,0,0,186,0,114,0,100,0,229,0,185,0,0,0,24,0,0,0,50,0,120,0,204,0,188,0,245,0,25,0,70,0,24,0,49,0,138,0,163,0,195,0,194,0,28,0,191,0,150,0,13,0,172,0,130,0,161,0,58,0,192,0,101,0,0,0,212,0,95,0,64,0,0,0,228,0,0,0,212,0,31,0,9,0,171,0,134,0,248,0,206,0,16,0,116,0,52,0,185,0,51,0,0,0,249,0,155,0,173,0,0,0,232,0,0,0,21,0,255,0,67,0,51,0,185,0,133,0,0,0,135,0,117,0,234,0,7,0,218,0,219,0,0,0,25,0,100,0,0,0,0,0,0,0,246,0,27,0,0,0,95,0,53,0,0,0,19,0,119,0,123,0,11,0,77,0,125,0,90,0,22,0,0,0,245,0,0,0,19,0,108,0,216,0,228,0,57,0,195,0,4,0,138,0,91,0,0,0,0,0,0,0,176,0,178,0,220,0,58,0,0,0,0,0,47,0,0,0,139,0,196,0,59,0,53,0,232,0,0,0,69,0,119,0,23,0,0,0,199,0,96,0,136,0,150,0,0,0,0,0,89,0,105,0,0,0,182,0,193,0,12,0,169,0,0,0,146,0,0,0,107,0,196,0,83,0,53,0,254,0,87,0,196,0,140,0,55,0,65,0,150,0,22,0,53,0,83,0,145,0,18,0,0,0,159,0,0,0,120,0,0,0,225,0,0,0,6,0,106,0,0,0,24,0,0,0,169,0,6,0,227,0,175,0,141,0,177,0,86,0,118,0,145,0,219,0,160,0,159,0,36,0,207,0,40,0,0,0,0,0,215,0,60,0,116,0,13,0,131,0,18,0,109,0,137,0,246,0,0,0,167,0,143,0,71,0,138,0,138,0,94,0,91,0,203,0,8,0,17,0,49,0,216,0,0,0,160,0,199,0,133,0,99,0,246,0,234,0,112,0,193,0,233,0,0,0,236,0,58,0,11,0,2,0,71,0,198,0,0,0,85,0,0,0,3,0,76,0,0,0,130,0,154,0,128,0,40,0,64,0,95,0,143,0,242,0,60,0,187,0,173,0,219,0,0,0,45,0,32,0,125,0,0,0,161,0,0,0,60,0,243,0,210,0,0,0,139,0,123,0,149,0,26,0,0,0,167,0,228,0,176,0,100,0,225,0,0,0,152,0,4,0,248,0,27,0,100,0,0,0,53,0,217,0,92,0,189,0,28,0,0,0,153,0,0,0,67,0,0,0,240,0,206,0,3,0,115,0,215,0,199,0,73,0,156,0,114,0,107,0,81,0,250,0,0,0,46,0,36,0,8,0,0,0,246,0,249,0,8,0,0,0,161,0,61,0);
signal scenario_full  : scenario_type := (0,0,0,0,33,31,21,31,21,30,134,31,118,31,65,31,223,31,223,30,138,31,138,30,80,31,80,30,193,31,180,31,180,30,56,31,181,31,181,30,239,31,9,31,252,31,142,31,34,31,26,31,230,31,221,31,169,31,162,31,207,31,31,31,31,30,31,29,31,28,31,27,255,31,255,30,217,31,217,30,182,31,209,31,217,31,178,31,63,31,103,31,103,30,18,31,18,30,186,31,114,31,100,31,229,31,185,31,185,30,24,31,24,30,50,31,120,31,204,31,188,31,245,31,25,31,70,31,24,31,49,31,138,31,163,31,195,31,194,31,28,31,191,31,150,31,13,31,172,31,130,31,161,31,58,31,192,31,101,31,101,30,212,31,95,31,64,31,64,30,228,31,228,30,212,31,31,31,9,31,171,31,134,31,248,31,206,31,16,31,116,31,52,31,185,31,51,31,51,30,249,31,155,31,173,31,173,30,232,31,232,30,21,31,255,31,67,31,51,31,185,31,133,31,133,30,135,31,117,31,234,31,7,31,218,31,219,31,219,30,25,31,100,31,100,30,100,29,100,28,246,31,27,31,27,30,95,31,53,31,53,30,19,31,119,31,123,31,11,31,77,31,125,31,90,31,22,31,22,30,245,31,245,30,19,31,108,31,216,31,228,31,57,31,195,31,4,31,138,31,91,31,91,30,91,29,91,28,176,31,178,31,220,31,58,31,58,30,58,29,47,31,47,30,139,31,196,31,59,31,53,31,232,31,232,30,69,31,119,31,23,31,23,30,199,31,96,31,136,31,150,31,150,30,150,29,89,31,105,31,105,30,182,31,193,31,12,31,169,31,169,30,146,31,146,30,107,31,196,31,83,31,53,31,254,31,87,31,196,31,140,31,55,31,65,31,150,31,22,31,53,31,83,31,145,31,18,31,18,30,159,31,159,30,120,31,120,30,225,31,225,30,6,31,106,31,106,30,24,31,24,30,169,31,6,31,227,31,175,31,141,31,177,31,86,31,118,31,145,31,219,31,160,31,159,31,36,31,207,31,40,31,40,30,40,29,215,31,60,31,116,31,13,31,131,31,18,31,109,31,137,31,246,31,246,30,167,31,143,31,71,31,138,31,138,31,94,31,91,31,203,31,8,31,17,31,49,31,216,31,216,30,160,31,199,31,133,31,99,31,246,31,234,31,112,31,193,31,233,31,233,30,236,31,58,31,11,31,2,31,71,31,198,31,198,30,85,31,85,30,3,31,76,31,76,30,130,31,154,31,128,31,40,31,64,31,95,31,143,31,242,31,60,31,187,31,173,31,219,31,219,30,45,31,32,31,125,31,125,30,161,31,161,30,60,31,243,31,210,31,210,30,139,31,123,31,149,31,26,31,26,30,167,31,228,31,176,31,100,31,225,31,225,30,152,31,4,31,248,31,27,31,100,31,100,30,53,31,217,31,92,31,189,31,28,31,28,30,153,31,153,30,67,31,67,30,240,31,206,31,3,31,115,31,215,31,199,31,73,31,156,31,114,31,107,31,81,31,250,31,250,30,46,31,36,31,8,31,8,30,246,31,249,31,8,31,8,30,161,31,61,31);

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
