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

constant SCENARIO_LENGTH : integer := 374;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (186,0,73,0,231,0,161,0,23,0,0,0,224,0,184,0,88,0,218,0,12,0,96,0,23,0,220,0,189,0,0,0,150,0,12,0,206,0,191,0,144,0,0,0,0,0,233,0,0,0,94,0,168,0,0,0,84,0,0,0,211,0,124,0,221,0,0,0,26,0,0,0,193,0,206,0,231,0,0,0,37,0,130,0,0,0,0,0,242,0,53,0,38,0,45,0,243,0,137,0,236,0,0,0,230,0,231,0,0,0,155,0,0,0,70,0,167,0,170,0,175,0,144,0,84,0,0,0,101,0,0,0,1,0,202,0,175,0,52,0,143,0,119,0,147,0,14,0,19,0,0,0,26,0,192,0,217,0,90,0,162,0,0,0,68,0,238,0,67,0,37,0,126,0,183,0,86,0,86,0,95,0,172,0,132,0,173,0,166,0,2,0,0,0,13,0,127,0,116,0,225,0,175,0,0,0,0,0,102,0,0,0,210,0,206,0,118,0,7,0,92,0,187,0,142,0,0,0,0,0,114,0,0,0,0,0,0,0,0,0,62,0,177,0,9,0,244,0,198,0,224,0,122,0,0,0,161,0,147,0,164,0,169,0,0,0,230,0,0,0,118,0,134,0,2,0,236,0,171,0,0,0,88,0,228,0,0,0,118,0,71,0,122,0,0,0,27,0,169,0,148,0,188,0,169,0,245,0,0,0,29,0,81,0,13,0,0,0,207,0,0,0,106,0,201,0,233,0,193,0,0,0,129,0,231,0,4,0,208,0,148,0,85,0,198,0,204,0,65,0,14,0,228,0,171,0,147,0,138,0,0,0,103,0,22,0,246,0,47,0,0,0,248,0,68,0,21,0,0,0,146,0,0,0,89,0,2,0,0,0,133,0,0,0,210,0,79,0,72,0,163,0,153,0,208,0,167,0,214,0,230,0,171,0,0,0,12,0,136,0,106,0,27,0,121,0,0,0,230,0,230,0,0,0,51,0,28,0,0,0,48,0,14,0,239,0,37,0,11,0,0,0,0,0,78,0,196,0,7,0,184,0,176,0,208,0,0,0,0,0,95,0,183,0,20,0,172,0,0,0,27,0,45,0,0,0,29,0,137,0,246,0,21,0,175,0,108,0,72,0,66,0,233,0,36,0,212,0,142,0,11,0,94,0,56,0,4,0,232,0,189,0,75,0,8,0,45,0,52,0,0,0,119,0,40,0,249,0,93,0,57,0,45,0,62,0,40,0,59,0,0,0,171,0,137,0,133,0,0,0,25,0,79,0,149,0,0,0,215,0,225,0,157,0,100,0,203,0,191,0,217,0,0,0,231,0,0,0,245,0,15,0,0,0,26,0,86,0,61,0,129,0,0,0,244,0,214,0,0,0,111,0,25,0,5,0,157,0,146,0,102,0,0,0,222,0,135,0,191,0,0,0,94,0,0,0,101,0,182,0,0,0,55,0,51,0,114,0,0,0,4,0,0,0,176,0,143,0,229,0,80,0,194,0,99,0,109,0,0,0,174,0,194,0,159,0,0,0,249,0,153,0,0,0,19,0,54,0,222,0,163,0,93,0,171,0,116,0,229,0,214,0,11,0,0,0,0,0,120,0,183,0,19,0,120,0,29,0,0,0,85,0,201,0,0,0,11,0,66,0,79,0,185,0,220,0,61,0,0,0,0,0,11,0,114,0,254,0);
signal scenario_full  : scenario_type := (186,31,73,31,231,31,161,31,23,31,23,30,224,31,184,31,88,31,218,31,12,31,96,31,23,31,220,31,189,31,189,30,150,31,12,31,206,31,191,31,144,31,144,30,144,29,233,31,233,30,94,31,168,31,168,30,84,31,84,30,211,31,124,31,221,31,221,30,26,31,26,30,193,31,206,31,231,31,231,30,37,31,130,31,130,30,130,29,242,31,53,31,38,31,45,31,243,31,137,31,236,31,236,30,230,31,231,31,231,30,155,31,155,30,70,31,167,31,170,31,175,31,144,31,84,31,84,30,101,31,101,30,1,31,202,31,175,31,52,31,143,31,119,31,147,31,14,31,19,31,19,30,26,31,192,31,217,31,90,31,162,31,162,30,68,31,238,31,67,31,37,31,126,31,183,31,86,31,86,31,95,31,172,31,132,31,173,31,166,31,2,31,2,30,13,31,127,31,116,31,225,31,175,31,175,30,175,29,102,31,102,30,210,31,206,31,118,31,7,31,92,31,187,31,142,31,142,30,142,29,114,31,114,30,114,29,114,28,114,27,62,31,177,31,9,31,244,31,198,31,224,31,122,31,122,30,161,31,147,31,164,31,169,31,169,30,230,31,230,30,118,31,134,31,2,31,236,31,171,31,171,30,88,31,228,31,228,30,118,31,71,31,122,31,122,30,27,31,169,31,148,31,188,31,169,31,245,31,245,30,29,31,81,31,13,31,13,30,207,31,207,30,106,31,201,31,233,31,193,31,193,30,129,31,231,31,4,31,208,31,148,31,85,31,198,31,204,31,65,31,14,31,228,31,171,31,147,31,138,31,138,30,103,31,22,31,246,31,47,31,47,30,248,31,68,31,21,31,21,30,146,31,146,30,89,31,2,31,2,30,133,31,133,30,210,31,79,31,72,31,163,31,153,31,208,31,167,31,214,31,230,31,171,31,171,30,12,31,136,31,106,31,27,31,121,31,121,30,230,31,230,31,230,30,51,31,28,31,28,30,48,31,14,31,239,31,37,31,11,31,11,30,11,29,78,31,196,31,7,31,184,31,176,31,208,31,208,30,208,29,95,31,183,31,20,31,172,31,172,30,27,31,45,31,45,30,29,31,137,31,246,31,21,31,175,31,108,31,72,31,66,31,233,31,36,31,212,31,142,31,11,31,94,31,56,31,4,31,232,31,189,31,75,31,8,31,45,31,52,31,52,30,119,31,40,31,249,31,93,31,57,31,45,31,62,31,40,31,59,31,59,30,171,31,137,31,133,31,133,30,25,31,79,31,149,31,149,30,215,31,225,31,157,31,100,31,203,31,191,31,217,31,217,30,231,31,231,30,245,31,15,31,15,30,26,31,86,31,61,31,129,31,129,30,244,31,214,31,214,30,111,31,25,31,5,31,157,31,146,31,102,31,102,30,222,31,135,31,191,31,191,30,94,31,94,30,101,31,182,31,182,30,55,31,51,31,114,31,114,30,4,31,4,30,176,31,143,31,229,31,80,31,194,31,99,31,109,31,109,30,174,31,194,31,159,31,159,30,249,31,153,31,153,30,19,31,54,31,222,31,163,31,93,31,171,31,116,31,229,31,214,31,11,31,11,30,11,29,120,31,183,31,19,31,120,31,29,31,29,30,85,31,201,31,201,30,11,31,66,31,79,31,185,31,220,31,61,31,61,30,61,29,11,31,114,31,254,31);

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
