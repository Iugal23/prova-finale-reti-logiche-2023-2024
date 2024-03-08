-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_512 is
end project_tb_512;

architecture project_tb_arch_512 of project_tb_512 is
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

constant SCENARIO_LENGTH : integer := 443;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (98,0,0,0,110,0,93,0,0,0,53,0,0,0,180,0,0,0,37,0,0,0,240,0,56,0,0,0,0,0,41,0,51,0,97,0,0,0,31,0,163,0,0,0,0,0,255,0,117,0,191,0,0,0,170,0,34,0,42,0,227,0,140,0,229,0,73,0,19,0,0,0,34,0,0,0,78,0,130,0,227,0,0,0,72,0,134,0,0,0,227,0,138,0,0,0,78,0,144,0,251,0,0,0,19,0,124,0,119,0,0,0,181,0,0,0,5,0,227,0,0,0,0,0,43,0,0,0,213,0,0,0,0,0,195,0,154,0,65,0,53,0,34,0,73,0,127,0,128,0,25,0,0,0,0,0,0,0,0,0,241,0,168,0,55,0,33,0,0,0,83,0,28,0,0,0,0,0,233,0,160,0,143,0,25,0,29,0,235,0,115,0,174,0,98,0,6,0,197,0,149,0,0,0,47,0,148,0,181,0,0,0,230,0,7,0,0,0,233,0,66,0,0,0,73,0,0,0,75,0,215,0,152,0,58,0,182,0,0,0,172,0,0,0,71,0,250,0,0,0,200,0,147,0,29,0,0,0,247,0,69,0,145,0,104,0,74,0,154,0,32,0,2,0,175,0,60,0,0,0,78,0,251,0,100,0,143,0,140,0,196,0,118,0,121,0,190,0,176,0,8,0,0,0,171,0,16,0,86,0,86,0,111,0,0,0,135,0,132,0,197,0,240,0,38,0,207,0,215,0,135,0,0,0,88,0,0,0,20,0,0,0,19,0,46,0,38,0,46,0,180,0,144,0,220,0,230,0,94,0,6,0,122,0,210,0,0,0,98,0,88,0,5,0,23,0,53,0,69,0,0,0,0,0,208,0,0,0,2,0,129,0,238,0,0,0,101,0,184,0,65,0,206,0,12,0,191,0,157,0,28,0,187,0,6,0,41,0,40,0,209,0,96,0,0,0,5,0,0,0,237,0,0,0,13,0,0,0,34,0,0,0,0,0,5,0,73,0,0,0,0,0,139,0,65,0,64,0,0,0,8,0,175,0,122,0,0,0,244,0,0,0,81,0,225,0,89,0,130,0,171,0,6,0,15,0,216,0,0,0,224,0,174,0,0,0,135,0,21,0,0,0,0,0,92,0,87,0,36,0,151,0,0,0,145,0,65,0,20,0,6,0,205,0,0,0,22,0,50,0,248,0,212,0,197,0,28,0,9,0,212,0,220,0,124,0,156,0,99,0,126,0,10,0,43,0,0,0,113,0,106,0,19,0,219,0,53,0,193,0,98,0,152,0,240,0,110,0,41,0,220,0,14,0,107,0,0,0,234,0,167,0,168,0,160,0,243,0,0,0,102,0,110,0,0,0,155,0,0,0,165,0,79,0,0,0,0,0,12,0,220,0,39,0,106,0,39,0,219,0,189,0,75,0,182,0,0,0,86,0,0,0,0,0,75,0,109,0,186,0,80,0,0,0,0,0,67,0,220,0,130,0,231,0,176,0,14,0,106,0,148,0,0,0,0,0,191,0,14,0,44,0,0,0,172,0,34,0,227,0,92,0,98,0,0,0,93,0,36,0,164,0,0,0,235,0,0,0,107,0,141,0,233,0,0,0,241,0,160,0,51,0,168,0,0,0,0,0,89,0,75,0,0,0,103,0,222,0,228,0,103,0,106,0,228,0,0,0,206,0,174,0,212,0,250,0,188,0,0,0,229,0,254,0,35,0,222,0,107,0,150,0,230,0,77,0,208,0,228,0,0,0,0,0,60,0,0,0,153,0,185,0,0,0,9,0,211,0,19,0,0,0,150,0,93,0,12,0,0,0,39,0,74,0,12,0,252,0,231,0,200,0,0,0,0,0,0,0,29,0,250,0,38,0,214,0,73,0,90,0,105,0,20,0,231,0,0,0,162,0,0,0,0,0,209,0,199,0,151,0,235,0,134,0,172,0,30,0,0,0,225,0,235,0,167,0,166,0,81,0,196,0,15,0,176,0);
signal scenario_full  : scenario_type := (98,31,98,30,110,31,93,31,93,30,53,31,53,30,180,31,180,30,37,31,37,30,240,31,56,31,56,30,56,29,41,31,51,31,97,31,97,30,31,31,163,31,163,30,163,29,255,31,117,31,191,31,191,30,170,31,34,31,42,31,227,31,140,31,229,31,73,31,19,31,19,30,34,31,34,30,78,31,130,31,227,31,227,30,72,31,134,31,134,30,227,31,138,31,138,30,78,31,144,31,251,31,251,30,19,31,124,31,119,31,119,30,181,31,181,30,5,31,227,31,227,30,227,29,43,31,43,30,213,31,213,30,213,29,195,31,154,31,65,31,53,31,34,31,73,31,127,31,128,31,25,31,25,30,25,29,25,28,25,27,241,31,168,31,55,31,33,31,33,30,83,31,28,31,28,30,28,29,233,31,160,31,143,31,25,31,29,31,235,31,115,31,174,31,98,31,6,31,197,31,149,31,149,30,47,31,148,31,181,31,181,30,230,31,7,31,7,30,233,31,66,31,66,30,73,31,73,30,75,31,215,31,152,31,58,31,182,31,182,30,172,31,172,30,71,31,250,31,250,30,200,31,147,31,29,31,29,30,247,31,69,31,145,31,104,31,74,31,154,31,32,31,2,31,175,31,60,31,60,30,78,31,251,31,100,31,143,31,140,31,196,31,118,31,121,31,190,31,176,31,8,31,8,30,171,31,16,31,86,31,86,31,111,31,111,30,135,31,132,31,197,31,240,31,38,31,207,31,215,31,135,31,135,30,88,31,88,30,20,31,20,30,19,31,46,31,38,31,46,31,180,31,144,31,220,31,230,31,94,31,6,31,122,31,210,31,210,30,98,31,88,31,5,31,23,31,53,31,69,31,69,30,69,29,208,31,208,30,2,31,129,31,238,31,238,30,101,31,184,31,65,31,206,31,12,31,191,31,157,31,28,31,187,31,6,31,41,31,40,31,209,31,96,31,96,30,5,31,5,30,237,31,237,30,13,31,13,30,34,31,34,30,34,29,5,31,73,31,73,30,73,29,139,31,65,31,64,31,64,30,8,31,175,31,122,31,122,30,244,31,244,30,81,31,225,31,89,31,130,31,171,31,6,31,15,31,216,31,216,30,224,31,174,31,174,30,135,31,21,31,21,30,21,29,92,31,87,31,36,31,151,31,151,30,145,31,65,31,20,31,6,31,205,31,205,30,22,31,50,31,248,31,212,31,197,31,28,31,9,31,212,31,220,31,124,31,156,31,99,31,126,31,10,31,43,31,43,30,113,31,106,31,19,31,219,31,53,31,193,31,98,31,152,31,240,31,110,31,41,31,220,31,14,31,107,31,107,30,234,31,167,31,168,31,160,31,243,31,243,30,102,31,110,31,110,30,155,31,155,30,165,31,79,31,79,30,79,29,12,31,220,31,39,31,106,31,39,31,219,31,189,31,75,31,182,31,182,30,86,31,86,30,86,29,75,31,109,31,186,31,80,31,80,30,80,29,67,31,220,31,130,31,231,31,176,31,14,31,106,31,148,31,148,30,148,29,191,31,14,31,44,31,44,30,172,31,34,31,227,31,92,31,98,31,98,30,93,31,36,31,164,31,164,30,235,31,235,30,107,31,141,31,233,31,233,30,241,31,160,31,51,31,168,31,168,30,168,29,89,31,75,31,75,30,103,31,222,31,228,31,103,31,106,31,228,31,228,30,206,31,174,31,212,31,250,31,188,31,188,30,229,31,254,31,35,31,222,31,107,31,150,31,230,31,77,31,208,31,228,31,228,30,228,29,60,31,60,30,153,31,185,31,185,30,9,31,211,31,19,31,19,30,150,31,93,31,12,31,12,30,39,31,74,31,12,31,252,31,231,31,200,31,200,30,200,29,200,28,29,31,250,31,38,31,214,31,73,31,90,31,105,31,20,31,231,31,231,30,162,31,162,30,162,29,209,31,199,31,151,31,235,31,134,31,172,31,30,31,30,30,225,31,235,31,167,31,166,31,81,31,196,31,15,31,176,31);

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
