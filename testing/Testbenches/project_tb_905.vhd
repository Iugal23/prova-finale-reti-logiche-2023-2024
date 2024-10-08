-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_905 is
end project_tb_905;

architecture project_tb_arch_905 of project_tb_905 is
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

constant SCENARIO_LENGTH : integer := 350;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (155,0,54,0,126,0,87,0,177,0,255,0,30,0,16,0,0,0,0,0,117,0,0,0,173,0,220,0,81,0,158,0,146,0,173,0,161,0,72,0,215,0,165,0,54,0,164,0,253,0,0,0,240,0,51,0,118,0,144,0,0,0,36,0,0,0,0,0,63,0,229,0,0,0,235,0,155,0,149,0,143,0,0,0,43,0,99,0,178,0,220,0,163,0,0,0,94,0,0,0,52,0,0,0,36,0,192,0,185,0,227,0,109,0,160,0,0,0,133,0,25,0,0,0,82,0,229,0,0,0,0,0,0,0,201,0,86,0,149,0,22,0,252,0,152,0,207,0,119,0,67,0,87,0,143,0,61,0,187,0,90,0,126,0,110,0,0,0,0,0,74,0,70,0,0,0,196,0,82,0,0,0,0,0,0,0,240,0,95,0,73,0,176,0,248,0,239,0,17,0,68,0,206,0,82,0,0,0,131,0,0,0,94,0,16,0,0,0,71,0,2,0,149,0,236,0,0,0,68,0,68,0,81,0,0,0,0,0,61,0,148,0,83,0,229,0,163,0,88,0,0,0,135,0,38,0,44,0,80,0,200,0,170,0,0,0,109,0,0,0,30,0,244,0,11,0,111,0,126,0,0,0,9,0,218,0,183,0,34,0,0,0,4,0,38,0,176,0,17,0,0,0,131,0,188,0,208,0,12,0,0,0,0,0,0,0,110,0,142,0,232,0,146,0,52,0,160,0,196,0,0,0,13,0,97,0,101,0,216,0,85,0,108,0,30,0,98,0,0,0,0,0,14,0,33,0,0,0,82,0,225,0,147,0,230,0,252,0,107,0,109,0,170,0,179,0,0,0,0,0,226,0,0,0,161,0,0,0,253,0,180,0,32,0,0,0,55,0,0,0,198,0,22,0,5,0,96,0,219,0,113,0,174,0,87,0,0,0,189,0,0,0,0,0,153,0,0,0,0,0,78,0,174,0,175,0,57,0,117,0,0,0,0,0,100,0,57,0,241,0,79,0,87,0,40,0,128,0,175,0,115,0,250,0,0,0,78,0,234,0,0,0,221,0,25,0,105,0,98,0,0,0,88,0,33,0,0,0,4,0,110,0,218,0,218,0,15,0,244,0,0,0,104,0,32,0,24,0,189,0,83,0,110,0,0,0,0,0,197,0,0,0,242,0,221,0,149,0,7,0,161,0,0,0,89,0,221,0,117,0,0,0,195,0,13,0,160,0,0,0,126,0,184,0,0,0,85,0,137,0,223,0,75,0,44,0,130,0,0,0,238,0,0,0,49,0,86,0,0,0,0,0,16,0,73,0,86,0,199,0,82,0,97,0,142,0,0,0,206,0,166,0,43,0,235,0,220,0,0,0,0,0,0,0,182,0,147,0,0,0,226,0,0,0,0,0,0,0,179,0,170,0,0,0,125,0,110,0,223,0,180,0,0,0,230,0,77,0,164,0,0,0,168,0,212,0,244,0,247,0,2,0,129,0,45,0,10,0,1,0,227,0,208,0,244,0,0,0,31,0,155,0,88,0,234,0,50,0,0,0,186,0,6,0,0,0,241,0,0,0);
signal scenario_full  : scenario_type := (155,31,54,31,126,31,87,31,177,31,255,31,30,31,16,31,16,30,16,29,117,31,117,30,173,31,220,31,81,31,158,31,146,31,173,31,161,31,72,31,215,31,165,31,54,31,164,31,253,31,253,30,240,31,51,31,118,31,144,31,144,30,36,31,36,30,36,29,63,31,229,31,229,30,235,31,155,31,149,31,143,31,143,30,43,31,99,31,178,31,220,31,163,31,163,30,94,31,94,30,52,31,52,30,36,31,192,31,185,31,227,31,109,31,160,31,160,30,133,31,25,31,25,30,82,31,229,31,229,30,229,29,229,28,201,31,86,31,149,31,22,31,252,31,152,31,207,31,119,31,67,31,87,31,143,31,61,31,187,31,90,31,126,31,110,31,110,30,110,29,74,31,70,31,70,30,196,31,82,31,82,30,82,29,82,28,240,31,95,31,73,31,176,31,248,31,239,31,17,31,68,31,206,31,82,31,82,30,131,31,131,30,94,31,16,31,16,30,71,31,2,31,149,31,236,31,236,30,68,31,68,31,81,31,81,30,81,29,61,31,148,31,83,31,229,31,163,31,88,31,88,30,135,31,38,31,44,31,80,31,200,31,170,31,170,30,109,31,109,30,30,31,244,31,11,31,111,31,126,31,126,30,9,31,218,31,183,31,34,31,34,30,4,31,38,31,176,31,17,31,17,30,131,31,188,31,208,31,12,31,12,30,12,29,12,28,110,31,142,31,232,31,146,31,52,31,160,31,196,31,196,30,13,31,97,31,101,31,216,31,85,31,108,31,30,31,98,31,98,30,98,29,14,31,33,31,33,30,82,31,225,31,147,31,230,31,252,31,107,31,109,31,170,31,179,31,179,30,179,29,226,31,226,30,161,31,161,30,253,31,180,31,32,31,32,30,55,31,55,30,198,31,22,31,5,31,96,31,219,31,113,31,174,31,87,31,87,30,189,31,189,30,189,29,153,31,153,30,153,29,78,31,174,31,175,31,57,31,117,31,117,30,117,29,100,31,57,31,241,31,79,31,87,31,40,31,128,31,175,31,115,31,250,31,250,30,78,31,234,31,234,30,221,31,25,31,105,31,98,31,98,30,88,31,33,31,33,30,4,31,110,31,218,31,218,31,15,31,244,31,244,30,104,31,32,31,24,31,189,31,83,31,110,31,110,30,110,29,197,31,197,30,242,31,221,31,149,31,7,31,161,31,161,30,89,31,221,31,117,31,117,30,195,31,13,31,160,31,160,30,126,31,184,31,184,30,85,31,137,31,223,31,75,31,44,31,130,31,130,30,238,31,238,30,49,31,86,31,86,30,86,29,16,31,73,31,86,31,199,31,82,31,97,31,142,31,142,30,206,31,166,31,43,31,235,31,220,31,220,30,220,29,220,28,182,31,147,31,147,30,226,31,226,30,226,29,226,28,179,31,170,31,170,30,125,31,110,31,223,31,180,31,180,30,230,31,77,31,164,31,164,30,168,31,212,31,244,31,247,31,2,31,129,31,45,31,10,31,1,31,227,31,208,31,244,31,244,30,31,31,155,31,88,31,234,31,50,31,50,30,186,31,6,31,6,30,241,31,241,30);

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
